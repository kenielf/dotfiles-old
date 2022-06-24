#!/usr/bin/env python
import sys
import os
import argparse
import json
import subprocess


def terminate(error_s: str, error_n: str = 1):
    print(f"\033[31m[{error_n}] Error: \033[37m{error_s}")
    sys.exit(error_n)


def verify_os():
    if sys.platform != "linux":
        terminate("This script must only be run on linux!")


def verify_euid():
    if os.geteuid() == 0:
        terminate("User must not be root!")


def check_deps():
    program_l = ["sudo", "python3"]
    missing_l = []
    for program in program_l:
        exit_c = subprocess.run(
            ["which", program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode
        if exit_c != 0:
            missing_l.append(program)
    if len(missing_l) != 0:
        terminate(f"Missing: {', '.join([str(i) for i in missing_l])}")


def preset_list(i_pwd):
    subfolders = [f.path for f in os.scandir(i_pwd) if f.is_dir()]
    ignore = [
        f"{i_pwd}/.git",
        f"{i_pwd}/doc",
        f"{i_pwd}/img",
        f"{i_pwd}/scripts"
    ]
    return [file.replace(f"{i_pwd}/", "") for file in subfolders if file not in ignore]


def options(i_pwd):
    try:
        parser = argparse.ArgumentParser(
            description="Dotfiles Configuration Applier in Python."
        )
        # * START ARGS
        parser.add_argument(
            "--preset", "-p",
            action="store",
            nargs=1,
            default=None,
            type=str,
            choices=preset_list(i_pwd),
            required=True,
            help="Choose the preset to apply.",
            dest="preset"
        )
        parser.add_argument(
            "--noconfirm", "-y",
            action="store_true",
            required=False,
            help="Skip the confirmation prompt. Not recommended.",
            dest="skip_confirm"
        )
        # * END ARGS
        args = parser.parse_args()
        return args
    except (argparse.ArgumentError, argparse.ArgumentTypeError) as error:
        terminate(error)


def backup_if_exists(target_path):
    # TODO: Properly investigate the behaviour behind existing directories
    # For the time being, copy and remove, rather than just moving or copying
    # seems to the trick well enough
    cp_cmd = f"sudo cp -rf \"{target_path}\" \"{target_path}.BAK\""
    rm_cmd = f"sudo rm -rf \"{target_path}\""
    subprocess.call([
        f"[ -f \"{target_path}\" ] && {cp_cmd} && {rm_cmd}", "||",
        f"[ -d \"{target_path}\" ] && {cp_cmd} && {rm_cmd}"
    ], shell=True)


def symlink(source_path, target_path):
    parent_dir = target_path.rpartition("/")[0:1]
    print(f"{target_path}: {parent_dir}")
    # Create the folder if the parent directory does not exist
    subprocess.call([
        f"sudo mkdir -p \"{parent_dir}\""
    ],shell=True)
    backup_if_exists(target_path)
    subprocess.call([
        f"sudo ln -sf \"{source_path}\" \"{target_path}\""
    ], shell=True)
    print(f"\033[34m{source_path}\033[37m --> \033[33m{target_path}\033[37m")


def copy(source_path, target_path):
    parent_dir = target_path.rpartition("/")[0:1]
    print(f"{target_path}: {parent_dir}")
    # Create the folder if the parent directory does not exist
    subprocess.call([
        f"sudo mkdir -p \"{parent_dir}\""
    ],shell=True)
    backup_if_exists(target_path)
    subprocess.call([
        f"sudo cp -rf \"{source_path}\" \"{target_path}\""
    ], shell=True)
    print(f"\033[34m{source_path}\033[37m --> \033[33m{target_path}\033[37m")


def warn(source_path, message_str):
    # TODO: Generate a log for the warnings.
    print(f"\033[33m>> Warning for \033[37m{source_path}\n{message_str}")


def main(active_dir, preset, skip=False):
    # * <-- Confirm preset application -->
    while True:
        # * <-- Skip user input if flag is set -->
        if skip:
            print("Skipping user input...")
            break
        else:
            print(f"\033[33mWarning: this will change system files!\033[37m")
            confirm_s = input("Apply configuration? [y/N]\n > ").upper()
        # * <-- Parse input -->
        if confirm_s.startswith("Y"):
            break
        elif confirm_s.startswith("N"):
            terminate("Not applying, exiting...")
        else:
            print("Invalid choice, try again.")
            continue
    # * <-- Read details.json and other files contained in the presets -->
    with open(f"{active_dir}/{preset}/details.json", "r") as content:
        data = json.loads(content.read())
        with open(f"{active_dir}/{data['preset_header']}") as header:
            preset_logo = header.read()
        with open(f"{active_dir}/{data['preset_packages']}") as packages:
            preset_packages = packages.read()
    # * <-- Set the correct values -->
    print(
        f"Applying preset\n\033[34m{preset_logo}\033[37m",
        f"-- {data['description']} --",
        sep=''
    )
    # * <-- Apply the configurations -->
    # Symlink
    print("Symlinking files...")
    for file in data['file_actions']['symlink']:
        source = f"{active_dir}/{preset}/{file['source']}".replace("//", "/")
        target = f"{file['target']}".replace(
            "$HOME", f"/home/{os.environ.get('USER', os.environ.get('USERNAME'))}")
        symlink(source, target)
    # Copy
    print("Copying files...")
    for file in data['file_actions']['copy']:
        source = f"{active_dir}/{preset}/{file['source']}".replace("//", "/")
        target = f"{file['target']}".replace(
            "$HOME", f"/home/{os.environ.get('USER', os.environ.get('USERNAME'))}")
        copy(source, target)
    # Warn
    for file in data['file_actions']['warn']:
        source = f"{active_dir}/{preset}/{file['source']}".replace("//", "/")
        message = file['message']
        warn(source, message)
    # Finish
    print("Installed dotfiles with directory backup enabled")


if __name__ == "__main__":
    # * <-- Make sure this program is running on linux and user is not root -->
    verify_os()
    verify_euid()
    # * <-- Check dependencies -->
    check_deps()
    # * <-- Get the current working directory -->
    cwd = os.getcwd()
    # * <-- Get user options and run main funct -->
    opts = options(cwd)
    try:
        main(cwd, opts.preset[0], opts.skip_confirm)
    except KeyboardInterrupt:
        print("\r\033[31mCancelling.\033[37m")
        exit
