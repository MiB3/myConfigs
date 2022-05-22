homebrew_home="${HOME}/homebrew"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gentoo"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://superuser.com/a/459057
__git_files () {
    _wanted files expl 'local files' _files
}
plugins=(git)
# autosuggestions were installed via homebrew (brew install autosuggestions)
source "${homebrew_home}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

## Here comes my personal stuff ##

arch=$(arch)

# better prompt
expectedPrompt='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '
if [ "$PROMPT" = "$expectedPrompt" ]; then
  PROMPT='%(!.%B%F{red}.%B%F{green}%D{%T} %n) %F{red}'${arch:0:1}' %{$fg_bold[black]%}%? %F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '
fi

alias code="open -a 'Visual Studio Code'"
alias fork="open -a 'Fork'"
alias beep="echo -ne '\007'"

load_jsc () {
  unalias jsc
  jsc=$(find /System/Library/Frameworks/JavaScriptCore.framework -iname jsc | head -1)
  alias jsc="${jsc}"
  "${jsc}" "$@"
}

alias jsc="load_jsc"

if [ "${arch}" = 'arm64' ]; then
  export PATH="${homebrew_home}_intel/bin:${PATH}"
  export PATH="${homebrew_home}_intel/sbin:${PATH}"
  export PATH="${homebrew_home}/bin:${PATH}"
  export PATH="${homebrew_home}/sbin:${PATH}"
else
  export PATH="${homebrew_home}/bin:${PATH}"
  export PATH="${homebrew_home}/sbin:${PATH}"
  export PATH="${homebrew_home}_intel/bin:${PATH}"
  export PATH="${homebrew_home}_intel/sbin:${PATH}"
fi

load_nvm () {
  unalias nvm
  unalias node
  unalias npm

  if [ -z "$NVM_DIR" ]; then
    if [ -f "${homebrew_home}_intel/opt/nvm/nvm.sh" ]; then
      # nvm
      export NVM_DIR="$HOME/.nvm"
      [ -s "${homebrew_home}_intel/opt/nvm/nvm.sh" ] && . "${homebrew_home}_intel/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "${homebrew_home}_intel/opt/nvm/etc/bash_completion.d/nvm" ] && . "${homebrew_home}_intel/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    fi;
  else
    echo "nvm already loaded"
  fi;
}

alias nvm="load_nvm && nvm"
alias node="load_nvm && node"
alias npm="load_nvm && npm"

# composer (php)
export PATH="${HOME}/.composer/vendor/bin:${PATH}"

# go (especially for air)
export PATH="$(go env GOPATH)/bin:${PATH}"

# ruby & chruby
# this lazy loading approach does not work for shebangs. shebangs will take up the system ruby if ruby() wasn't called yet.

load_chruby () {
  unalias ruby
  unalias chruby
  
  source "${homebrew_home}/opt/chruby/share/chruby/chruby.sh"
  chruby 3.0.2
}

alias ruby="load_chruby && ruby"
alias chruby="load_chruby && chruby"

# switch to intel shell
intel() {
  if [ "$(arch)" != 'i386' ]; then
    exec env /usr/bin/arch -x86_64 /bin/zsh --login
  else 
    echo 'Already on intel'
  fi
}
arm() {
  if [ "$(arch)" != 'arm64' ]; then
    exec env /usr/bin/arch -arm64 /bin/zsh --login
  else 
    echo 'Already on arm' 
  fi
}

# lighter autosuggest to better differentiate from the normal command.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

# asdf
. /Users/liip/homebrew/opt/asdf/libexec/asdf.sh