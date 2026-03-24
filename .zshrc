# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

setopt prompt_subst # enable env variable substitution within the prompt.

# Search through history with up and down keys with what was already typed. https://superuser.com/a/585004/575152
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

if which brew &>/dev/null; then
  homebrew_home="$(brew --prefix)"
fi

homebrew_zsh_autosuggestions_path="${homebrew_home}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ -f "$homebrew_zsh_autosuggestions_path" ]; then
  # autosuggestions were installed via homebrew (brew install zsh-autosuggestions)
  source "$homebrew_zsh_autosuggestions_path"
fi

arch=$(arch)
last_commit_time="00:00"

# better prompt
# shellcheck disable=SC2034,SC2016
PROMPT='%B%F{7}%D{%K:%M:%S} %F{8}${last_commit_time} %F{green}%n %F{red}'${arch:0:1}' %F{black}%? %F{blue}%(!.%1~.%~) %(!.%F{red}.%F{blue})$%k%b%f '

alias code="open -a 'Visual Studio Code'"
alias fork="open -a 'Fork'"
alias beep="echo -ne '\007'"

load_jsc () {
  unalias jsc
  jsc=$(find -L /System/Library/Frameworks/JavaScriptCore.framework -iname jsc | head -1)
  # shellcheck disable=SC2139
  alias jsc="${jsc}"
  "${jsc}" "$@"
}

alias jsc="load_jsc"

load_nvm () {
  # This assumes you installed nvm not via homebrew, but via the bash script from https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script.

  unalias nvm
  unalias node
  unalias npm
  unalias yarn

  if [ -z "$NVM_DIR" ]; then
    # From nvm install output:
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  fi;
}

alias nvm="load_nvm && nvm"
alias node="load_nvm && node"
alias npm="load_nvm && npm"
alias yarn="load_nvm && yarn"

# composer (php)
PATH="${HOME}/.composer/vendor/bin:${PATH}"

# go (especially for air)
if which go &>/dev/null; then
  PATH="$(go env GOPATH)/bin:${PATH}"
fi

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

# add custom user binaries to path
export PATH="${HOME}/bin:${PATH}"

# color every second line to better read log stuff. Use like: ls | colorOdd
colorOdd() {
  awk "NR%2 == 0 { print \"\033[107m\" \$0 \"\033[0m\"; next } { print \$0 }"
}  

export HOMEBREW_EDITOR="open -a 'Visual Studio Code'"

notify() {
  script="display notification \"$*\""
  osascript -e "$script"
}

preexec-time-hook() {
  time_hook_start="$(date +%s)"
}

notificationTime=$((5 * 60))
precmd-time-hook() {
  if [[ "${time_hook_start}" != "" ]]; then
    time_taken=$(( $(date +%s) - time_hook_start ))
    minutes=$(( time_taken / 60 ))
    seconds=$(( time_taken % 60 ))

    if (( minutes > 60 )); then
      hours=$(( minutes / 60 ))
      minutes=$(( minutes % 60 ))
      printf -v last_commit_time "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"
    else
      # shellcheck disable=SC2034
      printf -v last_commit_time "%02d:%02d" "$minutes" $seconds
    fi

    if (( time_taken > notificationTime )); then
      printf "\a"
    fi
  fi

  time_hook_start=""
}

if which add-zsh-hook &>/dev/null; then
  add-zsh-hook preexec preexec-time-hook
  add-zsh-hook precmd precmd-time-hook
fi

disable r # disable the built in r command so we can you r (the language).

alias PlistBuddy=/usr/libexec/PlistBuddy

# shellcheck disable=SC2139
alias diff-highlight="$homebrew_home/Cellar/git/2.51.2/share/git-core/contrib/diff-highlight/diff-highlight"

zshrc_local="$HOME/.zshrc_local"
if [ -f "$zshrc_local" ]; then
  source "$zshrc_local"
fi