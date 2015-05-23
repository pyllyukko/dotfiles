# prompt
charmap=$( locale charmap )
if [ "${charmap}" = "UTF-8" ]
then
  export PS1="\$? \$([ \$? -eq 0 ] && echo \"\[\033[01;32m\]\342\234\223\[\033[00m\]\" || echo \"\[\033[01;31m\]\342\234\227\[\033[00m\]\") \[\e]0;@\h \a\]@\h:\w\\$ "
fi

alias ls='ls --color=auto'
