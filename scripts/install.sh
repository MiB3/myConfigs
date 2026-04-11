#! /bin/bash

set -euxo pipefail

cd "$(dirname "$0")/.."
myConfigsFolder=$PWD

zshrcFile="$HOME/.zshrc"
if [ -f "$zshrcFile" ]; then
  echo ".zshrc file already exists. We will not symlink it."
else
  ln -s "$myConfigsFolder/.zshrc" "$HOME/.zshrc"
  echo "Success: .zshrc is now symlinked."
fi

launchAgentKey=com.milan.enable_keyboard_brightness_control
launchAgentFile="$HOME/Library/LaunchAgents/$launchAgentKey.plist"
if [ -f "$launchAgentFile" ]; then
  echo "$launchAgentFile already exists."
else
  echo "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
  <dict>
    <key>Label</key>
      <string>$launchAgentKey</string>
      <key>ProgramArguments</key>
      <array>
        <string>$myConfigsFolder/scripts/enable_keyboard_brightness_control.sh</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
  </dict>
</plist>
" > "$launchAgentFile"
  launchctl load "$launchAgentFile"
  echo "Success: launch agent file for keyboard brightness control successfully created and loaded."
fi