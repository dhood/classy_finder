#!/bin/sh
DEFAULT_FILENAME=classy_finder.png

SCRIPT_DIR=`dirname $0`


ICONS_DIR="${SCRIPT_DIR}"/Icons
mkdir -p -- "$ICONS_DIR"

# read in image to use for finder icon (possibly from command line argument)
filepath=${1:-${ICONS_DIR}/"$DEFAULT_FILENAME"}


if [ -f "$filepath" ] ; then # image found
	echo "New finder icon source: $filepath\n"

	# back up the original to the local directory
	sudo cp /System/Library/CoreServices/Dock.app/Contents/Resources/finder@2x.png ${ICONS_DIR}/finder_previous.png

	# copy in the new one
	sudo cp "$filepath" /System/Library/CoreServices/Dock.app/Contents/Resources/finder@2x.png
	sudo cp "$filepath" /System/Library/CoreServices/Dock.app/Contents/Resources/finder.png

	# trash the iconcache, forcing the dock to rebuild it
	sudo rm -f `find /private/var/folders -name com.apple.dock.iconcache 2> /dev/null`

	# restart the dock
	sudo killall Dock

	# output success
	echo "Icon has been changed. The Dock will re-appear soon.\n"

else
	echo "No/invalid image selected."
fi


