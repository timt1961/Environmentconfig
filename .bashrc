# .bashrc - Set up enviroment for bash shell

# If not running interactively, don't do anything
case $- in
   *i*);;
     *) return ;;
esac
#
# Command History
# Don't put duplicate lines or lines starting with space in the history
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to history file, do not overwrite
shopt -s histappend

# For setting history length, see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# Check the windowsize after each command and, if necessary, 
# Update the value of LINES and COLUMNS
shopt -s checkwinsize
# Find out where everything is
source /etc/os-release

case ${ID_LIKE} in

   debian)
	export GIT_PROMPT=/usr/lib/git-core/git-sh-prompt
	;;
   "rhel fedora")
	export GIT_PROMPT=/usr/share/git-core/contrib/completion/git-prompt.sh
	;;
   *)
	echo "ID_LIKE=$ID_LIKE"
	;;
esac

## Load completion
export BASH_COMPLETION_DIR="$(pkg-config --variable=completionsdir bash-completion)"
source "${BASH_COMPLETION_DIR}"/git
source ${GIT_PROMPT}

#Create the prompt
PS1='\D{%Y-%m%dT%H:%M:%S} \u@\h \W $(__git_ps1 "(%s)") \$ '

# Enable programmable completion featurs (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/pofile
# sources /etc/bash.bashrc
#
#  toggle the value of settings controlled optional shell behaviour
#  -o : restrict values of optname to those defined for set -o
#  -q : quiet mode
if ! shopt -oq posix; then
  if [ -f ${BASH_COMPLETION_DIR}/bash_completion ]; then
    . ${BASH_COMPLETION_DIR}/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load aliases
if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi
# load additional functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi


