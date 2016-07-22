/usr/bin/clear
history -c
#PID_FILE="${GNUPGHOME}/gpg-agent-info-$(hostname)"
#set -x
#if [ -r "${PID_FILE}" ]
#then
#  . "${PID_FILE}"
#  # if gpg-agent is running, flush all cached passphrases
#  if [ -n "${SSH_AGENT_PID}" ]
#  then
#    kill -SIGHUP ${SSH_AGENT_PID}
#  fi
#fi
killall -SIGHUP gpg-agent
