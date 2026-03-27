# myConfigs
A place for all my config files for different programs

# Sublime

    SUBLIME_USER_FOLDER="$HOME/Library/Application Support/Sublime Text/Packages/User"
    cp -r "$SUBLIME_USER_FOLDER"  'Sublime_User_Backup'
    rm -r "$SUBLIME_USER_FOLDER"
    ln -s myConfigs/MySublimeSettings "$SUBLIME_USER_FOLDER"

# VS Code

I could not fined a reliable way to link the VS Code settings to keep them in sync.

# .zshrc

    ln -s /full/path/to/myConfigs/.zshrc "$HOME/.zshrc"