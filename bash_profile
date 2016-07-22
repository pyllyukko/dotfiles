# ssh-keygen

export GNUPGHOME=~/.gnupg
PID_FILE="${GNUPGHOME}/gpg-agent-info-$(hostname)"

if grep -qs '^[[:space:]]*use-agent' "${GNUPGHOME}/gpg.conf" "${GNUPGHOME}/options"
then
  set -x
  if [ -r "${PID_FILE}" ]
  then
    . "${PID_FILE}"
    # these are required, so that gpg-agent detects whether it's running or not
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
  fi

  if ! /usr/bin/gpg-agent
  then
    /usr/bin/gpg-agent --daemon --enable-ssh-support --write-env-file=${PID_FILE}
  fi
  set +x
fi

if [ -f ~/.bashrc ]
then
  source ~/.bashrc
fi
