# myConfigs
A place for all my config files for different programs

# Sublime

    SUBLIME_USER_FOLDER="$HOME/Library/Application Support/Sublime Text/Packages/User"
    cp -r "$SUBLIME_USER_FOLDER"  'Sublime_User_Backup'
    rm -r "$SUBLIME_USER_FOLDER"
    ln -s myConfigs/MySublimeSettings "$SUBLIME_USER_FOLDER"

# VS Code

    VS_CODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    cp "$VS_CODE_SETTINGS"  'vs_code_settings_backup.json'
    rm "$VS_CODE_SETTINGS"
    # create a hardlink as vs code fails to read the softlink
    ln myConfigs/MyVSCodeSettings/settings.json "$VS_CODE_SETTINGS"