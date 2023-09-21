# Converter from ubuntu intune packages to fedora

Usage: `./build.sh`

# Enrolling

You might need to run:
`systemctl --user enable intune-agent.timer` as normal user.
`sudo systemctl enable --now microsoft-identity-device-broker`

Follow official insructions: https://learn.microsoft.com/en-us/mem/intune/user-help/enroll-device-linux

# Details

Fetchs packages described here: https://learn.microsoft.com/en-us/mem/intune/user-help/microsoft-intune-app-linux

# Troubleshooting

YMMV

* `sudo systemctl enable --now microsoft-identity-device-broker` does not start start the service or ends with exit code 1
    * make sure the JAVA_HOME environment variable in `/usr/lib/systemd/system/microsoft-identity-device-broker.service` is pointing to an existing directory
    * reboot

* launching Microsoft Intune from the desktop shortcut does nothing
    * make sure you aren't missing any packages needed to run the application
    * run it from the terminal for any tips on what they might be: `/opt/microsoft/intune/bin/intune-portal`

* After login attempt, the user is prompted by Intune to "Get the app". After accepting, authorization is not sent back to the Company Portal app. Blank page.
    * unsolved
