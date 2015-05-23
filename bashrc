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
