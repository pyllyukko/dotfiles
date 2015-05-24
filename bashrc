# prompt
charmap=$( locale charmap )
if [ "${charmap}" = "UTF-8" ]
then
  PS1="\$? \$([ \$? -eq 0 ] && echo \"\[\033[01;32m\]\342\234\223\[\033[00m\]\" || echo \"\[\033[01;31m\]\342\234\227\[\033[00m\]\") \[\e]0;@\h \a\]@\h:\w\\$ "
else
  PS1='\[\e]0;@\h \a\]@\h:\W\$ '
fi

LS_OPTIONS='--color=auto'
eval "`/usr/bin/dircolors -b`"
alias ls='ls ${LS_OPTIONS}'

shopt -s checkwinsize

HISTCONTROL="ignoreboth"

# set session timeout for root
if [ "${USER}" = "root" ]
then
  TMOUT=1200
fi

LESSHISTFILE="/dev/null"
LESSSECURE=1
if [ -f /usr/bin/lesspipe.sh ]
then
  LESSOPEN="|/usr/bin/lesspipe.sh %s"
elif [ -f /usr/bin/lesspipe ]
then
  LESSOPEN="|/usr/bin/lesspipe %s"
fi
export LESSOPEN
export PAGER="/usr/bin/less"
export EDITOR="/usr/bin/vim"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
