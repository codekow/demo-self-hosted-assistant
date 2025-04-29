#!/usr/bin/env bash

# create home
[ -z "${HOME}" ] && export HOME=/home/default
[ -d "${HOME}" ] || mkdir -p "${HOME}"

# set default user
if ! whoami &> /dev/null
then
  if [ -w /etc/passwd ] && [ -w /etc/group ]
  then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-default}:x:$(id -u):" >> /etc/group
  fi
fi

[ -f "${RAMALAMA_STORE}/models/ollama/${MODEL}" ] && ramalama pull ollama://"${MODEL}"

# shellcheck source=/dev/null
source /opt/intel/oneapi/setvars.sh

exec "${@}"
