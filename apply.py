#!/usr/bin/env python3
import sys
import os
import argparse
import json
import subprocess


def terminate(error_s: str, error_n: int = 1, colors=False):
    if colors == False:
        colors = {
            "RED": "",
            "RESET": ""
        }
    print(f"{colors['RED']}[{error_n}] Error: {colors['RESET']}{error_s}")
    sys.exit(error_n)


def background_checks(colors):
    issue_l = []
    # Verify the system
    if sys.platform != "linux":
        terminate("This script must only be run on linux!", 1, colors)
    # Check EUID
    if os.geteuid() == 0:
        issue_l.append("User must not be root!")
    # Check dependencies
    program_l = ["sudo", "python3"]
    missing_l = []
    for program in program_l:
        exit_c = subprocess.run(
            ["which", program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode
        if exit_c != 0:
            missing_l.append(program)
    if len(missing_l) != 0:
        issue_l.append(
            f"Missing commands: {', '.join([str(i) for i in missing_l])}!")
    terminate('; '.join(issue_l), 1, colors) if len(issue_l) != 0 else exit


def preset_list(i_pwd):
    subfolders = [f.path for f in os.scandir(i_pwd) if f.is_dir()]
    ignore = [
        f"{i_pwd}/.git",
        f"{i_pwd}/doc",
        f"{i_pwd}/img",
        f"{i_pwd}/scripts"
    ]
    preset_l = []
    for file in subfolders:
        if file not in ignore and os.path.isfile(f"{file}/details.json"):
            preset_l.append(file.replace(f"{i_pwd}/", ""))
    return preset_l


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
        parser.add_argument(
            "--nocolor",
            action="store_true",
            required=False,
            help="Disable color output",
            dest="disable_color"
        )
        # * END ARGS
        args = parser.parse_args()
        return args
    except (argparse.ArgumentError, argparse.ArgumentTypeError) as error:
        terminate(error, 1, colors=False)


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
    parent_dir = ''.join(target_path.rpartition("/")[0:1])
    # Create the folder if the parent directory does not exist
    subprocess.call([
        f"[ ! -d \"{parent_dir}\" ] && sudo mkdir -p \"{parent_dir}\""
    ], shell=True)
    backup_if_exists(target_path)
    subprocess.call([
        f"sudo ln -sfT \"{source_path}\" \"{target_path}\""
    ], shell=True)
    print(
        f"{colors['BLU']}{source_path}{colors['RESET']} --> {colors['YLW']}{target_path}{colors['RESET']}")


def copy(source_path, target_path, colors):
    parent_dir = ''.join(target_path.rpartition("/")[0:1])
    # Create the folder if the parent directory does not exist
    subprocess.call([
        f"[ ! -d \"{parent_dir}\" ] && sudo mkdir -p \"{parent_dir}\""
    ], shell=True)
    backup_if_exists(target_path)
    subprocess.call([
        f"sudo cp -rfT \"{source_path}\" \"{target_path}\""
    ], shell=True)
    print(
        f"{colors['BLU']}{source_path}{colors['RESET']} --> {colors['YLW']}{target_path}{colors['RESET']}")


def warn(source_path, message_str, colors):
    # TODO: Generate a log for the warnings.
    print(
        f"{colors['YLW']}>> Warning for {colors['RESET']}{source_path}\n{message_str}")


def main(active_dir, preset, colors, skip=False):
    # * <-- Confirm preset application -->
    while True:
        # * <-- Skip user input if flag is set -->
        if skip:
            print("Skipping user input...")
            break
        else:
            print(
                f"{colors['YLW']}Warning: this will change system files!{colors['RESET']}")
            confirm_s = input("Apply configuration? [y/N]\n > ").upper()
        # * <-- Parse input -->
        if confirm_s.startswith("Y"):
            break
        elif confirm_s.startswith("N"):
            terminate("Not applying, exiting...", 1, colors)
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
        f"Applying preset\n{colors['BLU']}{preset_logo}{colors['RESET']}",
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
        symlink(source, target, colors)
    # Copy
    print("Copying files...")
    for file in data['file_actions']['copy']:
        source = f"{active_dir}/{preset}/{file['source']}".replace("//", "/")
        target = f"{file['target']}".replace(
            "$HOME", f"/home/{os.environ.get('USER', os.environ.get('USERNAME'))}")
        copy(source, target, colors)
    # Warn
    for file in data['file_actions']['warn']:
        source = f"{active_dir}/{preset}/{file['source']}".replace("//", "/")
        message = file['message']
        warn(source, message, colors)
    # Finish
    print("Installed dotfiles with directory backup enabled")


if __name__ == "__main__":
    # * <-- Get the current working directory -->
    cwd = os.getcwd()
    # * <-- Get user options and run main funct -->
    opts = options(cwd)
    if opts.disable_color:
        clr = {
            "BLK": "",
            "RED": "",
            "GRN": "",
            "YLW": "",
            "BLU": "",
            "MGT": "",
            "CYN": "",
            "WHT": "",
            "RESET": ""
        }
    else:
        clr = {
            "BLK": "\033[30m",
            "RED": "\033[31m",
            "GRN": "\033[32m",
            "YLW": "\033[33m",
            "BLU": "\033[34m",
            "MGT": "\033[35m",
            "CYN": "\033[36m",
            "WHT": "\033[37m",
            "RESET": "\033[0m"
        }
    # * <-- Make sure the presets can be applied in the system -->
    background_checks(clr)
    try:
        main(cwd, opts.preset[0], clr, opts.skip_confirm)
    except KeyboardInterrupt:
        print(f"\r{clr['RED']}Cancelling.{clr['RESET']}")
        exit
