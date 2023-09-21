# Converter from ubuntu intune packages to fedora

Usage: `./build.sh`

# Enrolling

You might need to run:
`systemctl --user enable intune-agent.timer` as normal user.
`sudo systemctl enable --now microsoft-identity-device-broker`

Follow official insructions: https://learn.microsoft.com/en-us/mem/intune/user-help/enroll-device-linux

# Details

Fetchs packages described here: https://learn.microsoft.com/en-us/mem/intune/user-help/microsoft-intune-app-linux
