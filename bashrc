# prompt

# CentOS global bashrc
if [ -f /etc/bashrc ]
then
  source /etc/bashrc
fi

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

if [ -z "${BASH_COMPLETION_COMPAT_DIR}" -a -f /usr/share/bash-completion/bash_completion ]
then
  . /usr/share/bash-completion/bash_completion
fi

# jump between words with ctrl-(left|right)
# https://stackoverflow.com/questions/5029118/bash-ctrl-to-move-cursor-between-words-strings
bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
