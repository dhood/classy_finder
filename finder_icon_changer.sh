#!/bin/sh
DEFAULT_FILENAME=classy_finder.png # for command-line version only

SCRIPT_DIR=`dirname $0`

if [ -n "$SCRIPT_DIR" ] ; then 
# running from command line, might be argument passed in for image source

	ICONS_DIR="${SCRIPT_DIR}"/Icons
	mkdir -p -- "$ICONS_DIR"

	# read in image to use for finder icon
	filepath=${1:-${ICONS_DIR}/"$DEFAULT_FILENAME"}

else
# running from app

	SCRIPT_DIR="../Resources/"
	ICONS_DIR="${SCRIPT_DIR}"/Icons
	mkdir -p -- "$ICONS_DIR"

	# prompt user for image source location
	CD="CocoaDialog.app/Contents/MacOS/CocoaDialog"
	rv=`$CD fileselect \
	--text "Choose the source file for the new finder icon" \
	--with-directory $ICONS_DIR \
	--with-extensions .png .jpg .jpeg .bmp`
	if [ -n "$rv" ]; then 
		filepath=$rv
	else
		echo "Finder icon change cancelled."
	fi

fi

if [ -f "$filepath" ] ; then # image found
	echo "New finder icon source: $filepath\n"

	# back up the original to the local directory
	sudo cp /System/Library/CoreServices/Dock.app/Contents/Resources/finder@2x.png ${ICONS_DIR}/finder_previous.png

	# copy in the new one
	sudo cp "$filepath" /System/Library/CoreServices/Dock.app/Contents/Resources/finder@2x.png
	sudo cp "$filepath" /System/Library/CoreServices/Dock.app/Contents/Resources/finder.png

	# trash the iconcache, forcing the dock to rebuild it
	sudo rm -f `sudo find /private/var/folders -name com.apple.dock.iconcache`

	# restart the dock
	sudo killall Dock

	# output success
	echo "Icon has been changed. The Dock will re-appear soon.\n"

else
	echo "No/invalid image selected."
fi


