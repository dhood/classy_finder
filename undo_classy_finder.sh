#!/bin/sh

SCRIPT_DIR=`dirname $0`
ICON_DIR="$SCRIPT_DIR"/Icons

# copy the originals back to the original directory
sudo cp ${ICON_DIR}/finder_previous.png /System/Library/CoreServices/Dock.app/Contents/Resources/finder.png
sudo cp ${ICON_DIR}/finder_previous.png /System/Library/CoreServices/Dock.app/Contents/Resources/finder@2x.png

# trash the iconcache, forcing the dock to rebuild it
sudo rm -f `sudo find /private/var/folders -name com.apple.dock.iconcache 2> /dev/null`

# restart the dock
sudo killall Dock
