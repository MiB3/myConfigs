#! /bin/bash

set -euxo pipefail

echo "reboot automator ($0 $*) started $(date "+%d.%m.%Y %H:%M:%S")"

volume="Macintosh HD"
if [[ "$1" == "Arbeit" ]]; then
	volume="Work HD"
fi

container="$(diskutil list | grep "$volume" | grep -o "disk[0-9]" | head -1)"
currentContainer="$(bless --info --getBoot | grep "disk[0-9]")"

if [ "$container" != "$currentContainer" ]; then
	diskUtil mountDisk "$container"
fi

# Hide password.
set +x

command=(osascript -e 'Tell application "System Events" to display dialog "Automator needs administrator privileges:" default answer "" with hidden answer' -e 'text returned of result')
echo "+ ${command[*]}"
PASS="$("${command[@]}")"

command=(sudo -S bless --mount "/Volumes/$volume" --setboot --nextonly --verbose)
echo "+ ${command[*]}"
echo -e "$PASS\n\n" | "${command[@]}"
unset PASS

set -x

osascript -e 'tell app "System Events" to restart without state saving preference'