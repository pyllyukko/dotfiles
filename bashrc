# prompt

# CentOS global bashrc
if [ -f /etc/bashrc ]
then
  source /etc/bashrc
fi

charmap=$( locale charmap )
if [[ ${TERM} =~ ^xterm.* ]]
then
  TITLEBAR='\[\033]0;@\h\007\]'
else
  TITLEBAR=""
fi
if [ -z "${BASH_COMPLETION_COMPAT_DIR}" -a -f /usr/share/bash-completion/bash_completion ]
then
  . /usr/share/bash-completion/bash_completion
fi
if [ "${charmap}" = "UTF-8" ]
then
  if [ -f /usr/doc/git-*/contrib/completion/git-prompt.sh ]
  then
    . /usr/doc/git-*/contrib/completion/git-prompt.sh
  fi
  if declare -F __git_ps1 1>/dev/null
  then
    #PS1="${TITLEBAR}\$? \$([ \$? -eq 0 ] && echo \"\[\033[01;32m\]\342\234\223\[\033[00m\]\" || echo \"\[\033[01;31m\]\342\234\227\[\033[00m\]\") @\h:\w\$(__git_ps1 \" (%s)\")\\$ "
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWCOLORHINTS=true
    PROMPT_COMMAND='__git_ps1 "${TITLEBAR}${VIRTUAL_ENV:+($(basename ${VIRTUAL_ENV})) }\$? \$([ \$? -eq 0 ] && echo \"\[\033[01;32m\]\342\234\223\[\033[00m\]\" || echo \"\[\033[01;31m\]\342\234\227\[\033[00m\]\") @\h:\w" "\\\$ "'
  else
    PS1="${TITLEBAR}\$? \$([ \$? -eq 0 ] && echo \"\[\033[01;32m\]\342\234\223\[\033[00m\]\" || echo \"\[\033[01;31m\]\342\234\227\[\033[00m\]\") @\h:\w\\$ "
  fi
else
  PS1="${TITLEBAR}@\h:\W\\$ "
fi

# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$(/usr/bin/gpgconf --list-dirs agent-ssh-socket)"

# https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
if [ -n "${SSH_CONNECTION}" ]
then
  gpg-connect-agent updatestartuptty /bye
else
  # only use this locally
  alias gvim='gvim -p --servername gvim --remote-tab-silent'
fi

LS_OPTIONS='--color=auto'
eval "`/usr/bin/dircolors -b`"
alias ls='ls ${LS_OPTIONS}'
# http://vim.wikia.com/wiki/Enable_servername_capability_in_vim/xterm
# http://vim.wikia.com/wiki/Launch_files_in_new_tabs_under_Unix
export TAR_OPTIONS="--numeric-owner"
alias r2dump="r2 -c 'px \$s' -n -q"
alias r2file="r2 -c '/m' -n -q"
alias mucat="mutool draw -F txt"
alias ngrep="grep '^\(Nmap scan report for\|Host is\|PORT\|^[0-9]\+/[a-z]\+\s\+open[^|]\|Service Info\|OS details\|# Nmap done\)\b'"

threads=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
export	BUNDLEJOBS=${threads}
export	MAKEFLAGS="-j ${threads}"
unset	threads

if /usr/bin/gpg2 --version 2>/dev/null | head -1 | grep -q "^gpg.*2\.1.[0-9]\+$"
then
  alias gpg='/usr/bin/gpg2'
fi

shopt -s checkwinsize

HISTCONTROL="ignoreboth"
export HISTIGNORE="bitcoin-cli walletpassphrase *"

# set session timeout for root
if [ "${USER}" = "root" ]
then
  TMOUT=1200
fi

LESSHISTFILE="/dev/null"
LESSSECURE=1
# slackware
if [ -f /usr/bin/lesspipe.sh ]
then
  LESSOPEN="|/usr/bin/lesspipe.sh %s"
# debian
elif [ -f /usr/bin/lesspipe ]
then
  LESSOPEN="|/usr/bin/lesspipe %s"
fi
export LESSOPEN
export LESS="--RAW-CONTROL-CHARS"
export PAGER="/usr/bin/less -i"
export MANPAGER="/usr/bin/less -is"
export EDITOR="/usr/bin/vim"
#export GREP_OPTIONS="--color=auto"
if [ -n "${GOROOT}" ]
then
  export GOPATH="${HOME}/go"
  export PATH="${PATH}:${GOPATH}/bin"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# jump between words with ctrl-(left|right)
# https://stackoverflow.com/questions/5029118/bash-ctrl-to-move-cursor-between-words-strings
# stderr redirection because of "line ###: bind: warning: line editing not enabled"
bind '"\e[1;5C":forward-word' 2>/dev/null
bind '"\e[1;5D":backward-word' 2>/dev/null
# TODO: ctrl-backspace

# locales
# https://wiki.debian.org/Locale
# A4
export LC_PAPER=fi_FI.utf8
# week starts on monday
export LC_TIME=en_GB.utf8

# disable bracketed paste mode
# https://unix.stackexchange.com/questions/196098/copy-paste-in-xfce4-terminal-adds-0-and-1#196574
printf "\e[?2004l"

# https://github.com/pypa/pip/issues/8090
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
