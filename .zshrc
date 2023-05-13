homebrew_home="${HOME}/homebrew"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gentoo"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

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

## Here comes my personal stuff ##

arch=$(arch)
last_commit_time="00:00"

# better prompt
expectedPrompt='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%F{blue}%(!.#.$)%k%b%f '
if [ "$PROMPT" = "$expectedPrompt" ]; then
  PROMPT='%B%F{8}${last_commit_time} %F{green}%n %F{red}'${arch:0:1}' %F{black}%? %F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%(!.%F{red}.%F{blue})$%k%b%f '
fi

alias code="open -a 'Visual Studio Code'"
alias fork="open -a 'Fork'"
alias beep="echo -ne '\007'"

load_jsc () {
  unalias jsc
  jsc=$(find -L /System/Library/Frameworks/JavaScriptCore.framework -iname jsc | head -1)
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
  unalias yarn

  nvm_homebrew="${homebrew_home}"

  if [ -z "$NVM_DIR" ]; then
    if [ -f "${nvm_homebrew}/opt/nvm/nvm.sh" ]; then
      # nvm
      export NVM_DIR="$HOME/.nvm"
      [ -s "${homebrew_home}/opt/nvm/nvm.sh" ] && . "${homebrew_home}/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "${homebrew_home}/opt/nvm/etc/bash_completion.d/nvm" ] && . "${homebrew_home}/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    fi;
  else
    echo "nvm already loaded"
  fi;
}

alias nvm="load_nvm && nvm"
alias node="load_nvm && node"
alias npm="load_nvm && npm"
alias yarn="nvm use && yarn"

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
asdfFile="$HOME/homebrew/opt/asdf/libexec/asdf.sh"
if [[ -f "${asdfFile}" ]]; then
  . "${asdfFile}"
fi

# clang-tidy
clangTidyFile="${HOME}/homebrew_intel/opt/llvm@14/bin/clang-tidy"
if [[ -f "${clangTidyFile}" ]]; then
  alias clang-tidy="${clangTidyFile}"
fi

# add custom user binaries to path
export PATH="${HOME}/bin:${PATH}"

# color every second line to better read log stuff. Use like: ls | colorOdd
alias colorOdd='awk "NR%2 == 0 { print \"\033[107m\" \$0 \"\033[0m\"; next } { print \$0 }"'

export HOMEBREW_EDITOR="open -a 'Visual Studio Code'"

# Platform.sh CLI configuration
export PATH="$HOME/"'.platformsh/bin':"$PATH"
if [ -f "$HOME/"'.platformsh/shell-config.rc' ]; then 
  . "$HOME/"'.platformsh/shell-config.rc';
fi

shellcheck-all() {
  set -o pipefail
  git ls-files | grep '.*.sh$' | xargs shellcheck -C "$@" | sed "s/ line \(.*\):/:\1/g" 
}

alias shellcheck-all-fix="git ls-files | grep '.*.sh\$' | xargs shellcheck -f diff | git apply --allow-empty"

notify() {
  script="display notification \"$@\""
  osascript -e "$script"
}

preexec-time-hook() {
  time_hook_start="$(date +%s)"
}

notificationTime=$((5 * 60))
precmd-time-hook() {
  if [[ "${time_hook_start}" != "" ]]; then
    time_taken=$(( $(date +%s) - ${time_hook_start} ))
    minutes=$(( $time_taken / 60 ))
    seconds=$(( $time_taken % 60 ))

    if (( $minutes > 60 )); then
      hours=$(( $minutes / 60 ))
      minutes=$(( $minutes % 60 ))
      printf -v last_commit_time "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"
    else
      printf -v last_commit_time "%02d:%02d" "$minutes" $seconds
    fi

    if (( $time_taken > $notificationTime )); then
      printf "\a"
    fi
  fi

  time_hook_start=""
}

add-zsh-hook preexec preexec-time-hook
add-zsh-hook precmd precmd-time-hook

# always run valet on intel, since php is installed in brew intel.
valet() {
  if [ "$(arch)" != 'i386' ]; then
    echo "Error: valet needs to be executed in an intel shell"
    return 1
  fi

  command valet "$@"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !! Sort of ;-)
if [ -f "${HOME}/anaconda3/bin/conda" ]; then
  export CONDA_AUTO_ACTIVATE_BASE=false
  __conda_setup="$("${HOME}/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "${HOME}/anaconda3/etc/profile.d/conda.sh" ]; then
          . "${HOME}/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="${HOME}/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
fi
# <<< conda initialize <<<

disable r # disable the built in r command so we can you r (the language).

# fix for Docker on Mac with multiple users
# https://github.com/docker/for-mac/issues/6781#issuecomment-1541911185
export DOCKER_HOST=unix://$HOME/.docker/run/docker.sock
