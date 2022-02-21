# Useful functions

function setenv () {
  export $1="$2"
}

function unsetenv () {
  unset $1
}

function em () {
    /usr/bin/emacs -i -geometry 80x55+1 "$@"&
}

