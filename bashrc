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

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# todo.txt stuff
export TODO_TXT_DEFAULT_ACTION=ls
PATH=$PATH:"/home/heath/.todo/"
alias t="todo.sh -d /home/heath/.todo/todo.cfg"
complete -F _todo t
source /home/heath/.todo/todo_completion

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --color=auto'
alias ll='ls -l --color=auto'                              # long list
alias la='ls -Al --color=auto'                              # all but . and ..
alias l='ls -CF --color=auto'                              #

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
