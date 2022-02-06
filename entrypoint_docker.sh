#!/bin/sh
# We do this first to ensure sudo works below when renaming the user.
# Otherwise the current container UID may not exist in the passwd database.
DOCKER_SOCKET="${DOCKER_SOCKET:-/var/run/docker.sock}" 

eval "$(fixuid -q)"

if [ "${DOCKER_USER-}" ]; then
  USER="$DOCKER_USER"
  if [ "$DOCKER_USER" != "$(whoami)" ]; then
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
    # Unfortunately we cannot change $HOME as we cannot move any bind mounts
    # nor can we bind mount $HOME into a new home as that requires a privileged container.
    sudo usermod --login "$DOCKER_USER" coder
    sudo groupmod -n "$DOCKER_USER" coder

    sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd
  fi
fi

# change GID of group docker to match that of docker.sock
if test -e ${DOCKER_SOCKET}; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    sudo groupmod -g ${DOCKER_GID} docker
fi

dumb-init /usr/bin/code-server "$@"
