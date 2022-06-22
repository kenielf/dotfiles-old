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


def preset_list():
    # TODO: Make this function parse the repository instead of
    # *   returning a single manually-edited list.
    return ["insp3442-arch"]


def options():
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
            choices=preset_list(),
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
    subprocess.call([
        f"[ -f \"{target_path}\" ] && sudo mv -f \"{target_path}\" \"{target_path}.BAK\"",
        "||",
        f"[ -d \"{target_path}\" ] && sudo mv -f \"{target_path}\" \"{target_path}.BAK\""
    ], shell=True)


def symlink(source_path, target_path):
    backup_if_exists(target_path)
    subprocess.call([
        f"sudo ln -sf \"{source_path}\" \"{target_path}\""
    ], shell=True)
    print(f"\033[34m{source_path}\033[37m --> \033[33m{target_path}\033[37m")


def copy(source_path, target_path):
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
        if confirm_s == "Y" or confirm_s == "YES" or skip:
            break
        elif confirm_s == "N" or confirm_s == "NO":
            terminate("Not applying, exiting...")
        else:
            print("Invalid choice, try again.")
            continue
    # * <-- Read details.json and other files contained in the presets -->
    preset_json = str(f"{active_dir}/{preset}/details.json")
    with open(preset_json, "r") as content:
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


if __name__ == "__main__":
    # * <-- Make sure this program is running on linux and user is not root -->
    verify_os()
    verify_euid()
    # * <-- Get the current working directory -->
    cwd = os.getcwd()
    # * <-- Get user options and run main funct -->
    opts = options()
    try:
        main(cwd, opts.preset[0], opts.skip_confirm)
    except KeyboardInterrupt:
        print("\r\033[31mCancelling.\033[37m")
        exit
