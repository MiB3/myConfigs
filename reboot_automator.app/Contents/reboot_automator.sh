#! /bin/bash

set -euxo pipefail

echo "reboot automator ($0 $*) started $(date "+%d.%m.%Y %H:%M:%S")"

volume="Macintosh HD"
if [[ "$1" == "Arbeit" ]]; then
	volume="Work HD"
fi

# The other system's volume might not be mounted while booted from this one.
if [ ! -e "/Volumes/$volume" ]; then
	container="$(diskutil info -plist "$volume" | plutil -extract APFSContainerReference raw -)"
	diskutil mountDisk "$container"
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

	# turn
	# {"bless", "--mount", "/Volumes/Work HD", "--setboot", "--nextonly", "--verbose"}
	# into
	# 'bless' '--mount' '/Volumes/Work HD' '--setboot' '--nextonly' '--verbose'
	repeat with arg in argv
		# cmd = cmd + "$arg" + " "
		set cmd to cmd & quoted form of arg & " "
	end repeat

	do shell script cmd with prompt "Reboot Automator wants to change the startup disk." with administrator privileges
end run
EOF
fi

defaults write com.apple.loginwindow TALLogoutSavesState -bool false
osascript -e 'tell app "System Events" to restart with state saving preference'