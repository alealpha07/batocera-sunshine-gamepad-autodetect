#!/bin/bash
set -e

SERVICE_NAME="sunshine_gamepad_autodetect"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="/userdata/system/sunshine-gamepad-autodetect"
SERVICES_DIR="/userdata/system/services"

batocera-services stop "$SERVICE_NAME" 2>/dev/null || true

mkdir -p "$INSTALL_DIR" "$SERVICES_DIR"
cp "$SOURCE_DIR/bin/emulatorlauncher-wrapper" "$INSTALL_DIR/emulatorlauncher-wrapper"
cp "$SOURCE_DIR/services/$SERVICE_NAME" "$SERVICES_DIR/$SERVICE_NAME"
chmod 755 "$INSTALL_DIR/emulatorlauncher-wrapper" "$SERVICES_DIR/$SERVICE_NAME"

batocera-services enable "$SERVICE_NAME"
batocera-services start "$SERVICE_NAME"
batocera-services status "$SERVICE_NAME"
