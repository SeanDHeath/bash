# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTSIZE=""

# Set up fzf
export FZF_CTRL_R_OPTS='--sort'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
source $HOME/.config/bash/completion.bash 2>/dev/null
source $HOME/.config/bash/key-bindings.bash 2>/dev/null

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() (
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
)

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() (
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
)

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# Find file from root
ff(){
    find / -name "$1" 2>/dev/null
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function
cf() {
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

fhelp(){
    echo ""
    echo "# KEYBINDINGS"
    echo "CTRL-T - Paste selected files onto command line"
    echo "CTRL-R - Paste selected commands from history onto command line"
    echo "ALT-C  - cd into the selected directory"
    echo ""
    echo "# FILES"
    echo "fo     - open file, CTRL-O to open, CTRL-E to edit"
    echo "fe     - edit file, search for title"
    echo "fif    - find in file, grep for string and view contents"
    echo ""
    echo "# DIRECTORIES"
    echo "fd     - find directory"
    echo "fda    - find directory includes dotfiles"
    echo "cf     - cd from anywhere"
    echo "cdf    - cd into directory containing selected file"
    echo ""
    echo "# GIT"
    echo "fcoc   - checkout commit"
    echo "fshow  - commit browser"
    echo ""
    echo "# PROCESSES"
    echo "fkill  - kill process"
    echo ""
}

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# xz compression
alias xxz='XZ_OPT=-T0 tar xvJf'
alias cxz='XZ_OPT=-T0 tar cvJf'

# nordvpn
alias nordu='sudo systemctl start nordvpnd;nordvpn c us'
alias nordd='sudo systemctl stop nordvpnd'

# virt-manager
alias vmu='sudo systemctl start libvirtd;sudo virsh net-start default;virt-manager'
alias vmd='sudo systemctl stop libvirtd;sudo virsh net-destroy default'

# Misc
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias resetcac="sudo systemctl restart pcscd"

# Config management
alias runcfg='~/.linuxconfig/setup.sh'
function pushcfg() {
  dir=$(pwd)
  cd ~/.linuxconfig
  git push origin master
  cd $dir
}
function addpkg() {
  echo "$1" >> ~/.config/linuxconfig/packages
}

# Some shortcuts for different directory listings
alias ls='ls -hF --color=auto'
alias ll='ls -l --color=auto'                              # long list
alias la='ls -Al --color=auto'                              # all but . and ..
alias l='ls -CF --color=auto'                              #

# aws cli
function daws(){
  aws "$@" --profile dftc
}



# Prompt
source ~/.git-prompt.sh
BLACK='\e[0;30m'        # Black
RED='\e[0;31m'          # Red
GREEN='\e[0;32m'        # Green
YELLOW='\e[0;33m'       # Yellow
BLUE='\e[0;34m'         # Blue
PURPLE='\e[0;35m'       # Purple
CYAN='\e[0;36m'         # Cyan
WHITE='\e[0;37m'        # White
export PS1="\[$GREEN\]\t\[$RED\]-\[$CYAN\]\u@\h\[$YELLOW\]\[$YELLOW\]\w\[\033[m\]\[$PURPLE\]\$(__git_ps1)\[$WHITE\]\$ "
