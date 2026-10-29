#!/bin/bash

SERVICE_NAME="sunshine_gamepad_autodetect"

batocera-services stop "$SERVICE_NAME"
batocera-services disable "$SERVICE_NAME"
rm -f "/userdata/system/services/$SERVICE_NAME"
rm -rf "/userdata/system/sunshine-gamepad-autodetect" "/var/run/sunshine-gamepad-autodetect"
rm -f "/userdata/system/logs/sunshine-gamepad-autodetect.log"
echo "${SERVICE_NAME}: removed"
