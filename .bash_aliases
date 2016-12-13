function em(){
   if [ "$DISPLAY" = ":0" -o "$DISPLAY" = ":0.0" ]
   then
     emacs -geometry 80x40 -i $@ &
   else 
     emacs -nw $@;
   fi
}
export -f em

function setenv(){
 export $1="$2"
}
function unsetenv(){
 unset $1
}
export -f setenv
export -f unsetenv

alias l='ls -l'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
