# Converter from ubuntu intune packages to fedora

## Build

`./build.sh`

## Install

`./install.sh`

Reboot. intune needs some dbus and other services to be running since the start of the machine and before loggin in.

# Enrolling

Follow official insructions: https://learn.microsoft.com/en-us/mem/intune/user-help/enroll-device-linux

I think it means that you install Microsoft Edge, login there as your nitor.com user and then start the agent.

Run `/opt/microsoft/intune/bin/intune-portal`

# Details

Fetchs packages described here: https://learn.microsoft.com/en-us/mem/intune/user-help/microsoft-intune-app-linux

# Troubleshooting

YMMV

* Not sure if the dbus/timer/socket activations work for all the services, so you can try one of these:
    * `sudo systemctl enable --now microsoft-identity-device-broker`
    * `systemctl --user enable --now microsoft-identity-broker`
    * `systemctl --user enable --now intune-agent.timer`

* launching Microsoft Intune from the desktop shortcut does nothing
    * make sure you aren't missing any packages needed to run the application
    * run it from the terminal for any tips on what they might be: `/opt/microsoft/intune/bin/intune-portal`

* After login attempt, the user is prompted by Intune to "Get the app". After accepting, authorization is not sent back to the Company Portal app. Blank page.
    * unsolved
