alias xterm='xterm -ut'        #This stops us making an entry in utmp
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F'
alias dir='ls -F'
alias l='ls -l'
alias etel='ypcat -k aliases | grep'

alias lsco='cleartool lsco -avobs -cview'
alias lsprivate='cleartool lsprivate -other'
alias vt='cleartool lsvtree -graphical'
alias ct='cleartool'
alias cq='clearquest -clean'
alias lsview='cleartool lsview -s "${USER}*"'
alias cpe='\cp /sdev/user/etc/clearprojexp.dat ${HOME}/.Rational/ClearCase/clearprojexp;clearprojexp'
alias h='history'
#alias cadenv='cadenv \!{*} ; rehash'

