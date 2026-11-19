#!/bin/bash

SERVICE_NAME="sunshine_gamepad_autodetect"

INSTALL_DIR="/userdata/system/sunshine-gamepad-autodetect"
SWITCH_CFG="/userdata/system/configs/emulationstation/es_systems_switch.cfg"
SWITCH_RUN="/userdata/system/switch/launch/run.py"

batocera-services stop "$SERVICE_NAME"
batocera-services disable "$SERVICE_NAME"

# Restore the Switch add-on launch command before the wrapper is deleted
if [ -f "$SWITCH_CFG" ]; then
    sed -i "s|python $INSTALL_DIR/emulatorlauncher-wrapper --exec $SWITCH_RUN |python $SWITCH_RUN |" "$SWITCH_CFG"
fi
rm -f "/userdata/system/services/$SERVICE_NAME"
rm -rf "/userdata/system/sunshine-gamepad-autodetect" "/var/run/sunshine-gamepad-autodetect"
rm -f "/userdata/system/logs/sunshine-gamepad-autodetect.log"
echo "${SERVICE_NAME}: removed"
