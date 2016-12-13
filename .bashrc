# @(#).bashrc 1.3 88/02/08 SMI
###############################################################
#
#	.bashrc file
#
#	initial setup file for both interactive and noninteractive
#       C-Shells
#
#       cloned from .cshrc
# Reworked on 05/09/1995
#############################################################
export DOTBASHRCSTART=`date +%s`
#echo "This is .bashrc"
#echo "BASHRC Start : Path $PATH"
#echo "OS_ : $os_ (before))"
SHELL=/bin/bash
#source /sdev/defaults/gencsh   # general aliases.
os_=`uname -s`
on_=`uname -n`

function setenv () {
  export $1="$2"
}

function unsetenv () {
  unset $1
}

#----------------------------------------------------------------------------#
# ClearCase environmental logic.
#----------------------------------------------------------------------------#
#
# The CLEARCASE_ROOT environment variable is set by ClearCase during the
# "setview" operation. Thus, if this variable is set then it is safe to assume
# that the current shell was either the result of a "cleartool setview"
# command or a sub-shell in an active ClearCase view.
#
#
if [[ -n "$CLEARCASE_ROOT" ]]
then
  # Assume we have to source the new environment
  switchview_=1

  # Do we have a view already set?
  if [[ -n "$SCM_OLD_ROOT" ]]
  then
    # Yes we have a view, is it the same view?
    if [[ ${SCM_OLD_ROOT} = ${CLEARCASE_ROOT} ]]
    then
      # Yes same view, skip the environment script
      switchview_=0
    fi
  fi

  # Should I source the environment script?
  if [[ ${switchview_} = 1 ]]
  then

    # Get root directory
    root_=$(/sdev/defaults/getclusterroot)

    if [[ -n "${root_}" ]]
    then
        # found a root

        envfile_=${root_}/scm/context/env.ksh

        if [[ ! -r ${envfile_} ]]
        then
          # Legacy mode, do the same things as in the past
          envfile_=/sdev/user/etc/ccset_env.ksh
        fi
        # Source the file
        . ${envfile_}
        unset envfile_

    fi # ${root_}

    export SCM_OLD_ROOT=$CLEARCASE_ROOT
    unset root_

  fi # ${switchview_} = 1
  # Cleanup local variables
  unset switchview_
  export PS1="\h:$(if [[ -n "${SCM_WS}" ]]; then echo \[${CLEARCASE_ROOT##*/}\];fi) \$ "

else # Possible git environment. Load up
    #
    # see http://code-worrier.com/blog/autocomplete-git/
#    echo "bashrc Sourcing git autocomplete"
    if [ -f ~/bin/git_completion.sh ]; then
        if [ `uname` == 'Linux' ]
        then
            source ~/bin/git_completion.sh
        fi
    fi
    #
    # See http://code-worrier.com/blog/git-branch-in-bash-prompt/ for details
    if [ `uname` == 'Linux' ]
    then
        source /home/utt/bin/git_prompt.sh
        PS1="\t-\h:\w\$(__git_ps1) \$ "
    fi
#    echo "bashrc: not clearcase: set ps1"

fi # "$CLEARCASE_ROOT"

host=`uname -n`
	

#limit coredumpsize unlimited
#PS1=$host"$ "
# have the titlebar display the current workspace
#export PS1='\h $ '
#export PS1="\h:$(if [[ -n "${SCM_WS}" ]]; then echo \[${CLEARCASE_ROOT##*/}\];fi) \$ "
#export PS1

#if  [ "$SCM_WS" != "" ] ; then 
#   prefix=`basename $SCM_WS`
#   PS1="\h ("$CURRENTVIEW") $ "
#fi

#
# Clever little function which starts emacs... Could be that this only works under
# a window manager...
function em {
#    if [ -x /usr/bin/emacs ]; then
#	LD_LIBRARY_PATH=/scratch/lib:$LD_LIBRARY_PATH
#	/usr/bin/emacs -i -geometry 80x63+1 "$@"&
#    else
#	/home/utt/cadbin/emacs -i -geometry 80x63+1 "$@"&
        /cws/utt/linux/bin/emacs -i -geometry 80x55+1 "$@"&
#    fi
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac


#	skip remaining setup if not an interactive shell

#if ($?USER == 0 || $?prompt == 0) exit


#alias awk=nawk

#alias crpr='xterm -title CRPR -e crpr&'


PRP="`uname -n`:[${USER}]"	  ; export PRP
#
#
export LC_TYPE=iso_8859_1
#
#
# This stuff was lifted from the examples files... It will help to 
# set the environmnent
# setenv VAR VALUE
#
# Setup for pycharm
if [ -d /cadappl/jdk ]
then
  export PYCHARM_JDK='/cadappl/jdk/1.7.0.15/jdk'
  alias pycharm='/cws/utt/pycharm-community-3.4.1/bin/pycharm.sh'
fi
#
# set up umask
# umask 022  # rw-r-r ;temporarily deactivated: this may break codemanager
#echo "Sourcing alias"
if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi
#echo "Sourcing profile"
source ~/.profile

#
# I have a very distinct preference for the editor
#
export EDIT=emacs
export EDITOR=emacs
export MY_EDITOR=emacs

#echo ".bashrc done "
export DOTBASRHCEND=`date +%s`

#
# Virtualenv wrapper settings
#export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/Django-projects
#source /usr/bin/virtualenvwrapper.sh

