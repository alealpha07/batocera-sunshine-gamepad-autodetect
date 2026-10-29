# batocera-sunshine-gamepad-autodetect

A  [Batocera](https://batocera.org/) service that makes [Sunshine](https://github.com/LizardByte/Sunshine) virtual gamepads the first players whenever a game starts.

Built for a Batocera machine used as a remote arcade cabinet: local arcade sticks are always plugged in, and remote players join through Sunshine / Moonlight. Without this service, EmulationStation keeps giving P1 and P2 to the arcade sticks and the remote players have to swap controllers by hand in the menu every session.

With the service enabled:

| Connected                     | P1        | P2        | P3      | P4      |
| ----------------------------- | --------- | --------- | ------- | ------- |
| 2 arcade sticks               | stick 1   | stick 2   |         |         |
| 1 Sunshine pad + 2 sticks     | Sunshine  | stick 1   | stick 2 |         |
| 2 Sunshine pads + 2 sticks    | Sunshine  | Sunshine  | stick 1 | stick 2 |

Any number of Sunshine pads is supported (up to Batocera's 8 players), and any emulated pad type works (Xbox 360/One, DualSense, Switch…): a pad counts as remote when its name contains `sunshine`.

## Why it is needed

EmulationStation assigns players in `InputManager::computePlayersConfigs()` by matching the saved device path, then the exact name + GUID, then the exact name. Free slots are filled with the remaining controllers sorted by sysfs path, and USB devices (`/sys/devices/pci…`) always sort before virtual ones (`/sys/devices/virtual/…`), so the arcade sticks win. Sunshine creates a new virtual device for every session, and its name changes with the emulated pad type, so a saved choice does not survive.

## How it works

EmulationStation starts every game through `/usr/bin/emulatorlauncher`, passing the chosen controllers as `-p1index -p1guid -p1name …` arguments. When the service starts, it bind-mounts a small wrapper over that file. The wrapper moves the players whose name contains `sunshine` to the front, renumbers them, and then runs the original launcher.

- Only the controllers EmulationStation passes in are reordered, so pads that are not connected are never assigned.
- If no Sunshine pad is connected, the arguments are passed through untouched.
- If anything goes wrong while reordering, the game starts with the original arguments.
- Nothing runs in the background. Stopping the service removes the bind mount, and the system files are never modified on disk.

## Requirements

- Batocera with user services support (`batocera-services`). Tested on Batocera 43.
- Sunshine installed and streaming gamepads to the machine.

## Install

Copy the repository to the Batocera machine and run the installer:

```sh
bash install.sh
```

The installer copies:

- `services/sunshine_gamepad_autodetect` to `/userdata/system/services/`
- `bin/emulatorlauncher-wrapper` to `/userdata/system/sunshine-gamepad-autodetect/`

It then enables and starts the service. It is safe to run it again to update.

## Enable / disable

From EmulationStation: **Main menu → System settings → Services → `sunshine_gamepad_autodetect`**.

## Uninstall

```sh
bash uninstall.sh
```

This stops and disables the service and removes its files and log.

## Limitations

- The controller menu in EmulationStation still shows its own order. The new order applies inside the game.
- A Sunshine pad that connects while a game is already running is picked up from the next game launch.
- Hotkeys handled only on player 1 (like Hotkey + Start to exit) follow the new P1, which is the first Sunshine pad.

## License

[MIT](LICENSE)
