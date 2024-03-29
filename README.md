# Converter from Ubuntu Intune packages to Fedora

## Build

Requires `podman` or `docker` to be installed.

```bash
./build.sh
```

## Install

```bash
./install.sh
```

Reboot. Intune needs some dbus and other services to be running since the start of the machine and before logging in.

## Enroll

Start the wizard by running:

```bash
/opt/microsoft/intune/bin/intune-portal
```

Follow the instructions. Requires logging in with your Nitor AD credentials and verifying the authentication with the authenticator app.

If it says at the end that the devide is not comliant, check the details, it may be that you just need to wait for a while and refresh the status.

It may take up to 4 hours for your device to appear in Iron Bank user interface, as the data is synchronized every 4 hours.

### Details

Official insructions: <https://learn.microsoft.com/en-us/mem/intune/user-help/enroll-device-linux>

Fetchs packages described here: <https://learn.microsoft.com/en-us/mem/intune/user-help/microsoft-intune-app-linux>

## Troubleshooting

YMMV

* Not sure if the dbus/timer/socket activations work for all the services, so you can try one of these:
  * `sudo systemctl enable --now microsoft-identity-device-broker`
  * `systemctl --user enable --now microsoft-identity-broker`
  * `systemctl --user enable --now intune-agent.timer`

* launching Microsoft Intune from the desktop shortcut does nothing
  * make sure you aren't missing any packages needed to run the application
  * run it from the terminal for any tips on what they might be: `/opt/microsoft/intune/bin/intune-portal`
