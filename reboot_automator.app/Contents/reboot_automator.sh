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

command=(bless --mount "/Volumes/$volume" --setboot --nextonly --verbose)

# Touch ID via sudo (needs pam_tid.so in /etc/pam.d/sudo_local). Without a terminal
# sudo can't ask for a password, so fall back to the system authorization dialog.
if sudo -v </dev/null; then
	sudo "${command[@]}"
else
	osascript - "${command[@]}" <<'EOF'
on run argv
	set cmd to ""
	repeat with arg in argv
		set cmd to cmd & quoted form of arg & " "
	end repeat
	do shell script cmd with prompt "Reboot Automator wants to change the startup disk." with administrator privileges
end run
EOF
fi

osascript -e 'tell app "System Events" to restart without state saving preference'