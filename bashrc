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
