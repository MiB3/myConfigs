# myConfigs
A place for all my config files for different programs

# Sublime

    SUBLIME_USER_FOLDER='~/Library/Application Support/Sublime Text/Packages/User'
    cp "$SUBLIME_USER_FOLDER"  'Sublime_User_Backup'
    rm -r "$SUBLIME_USER_FOLDER"
    ln -s myConfigs/MySublimeSettings "$SUBLIME_USER_FOLDER"