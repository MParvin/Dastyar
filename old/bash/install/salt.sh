#!/bin/bash -x

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi

function show_help() {
      echo -e " Usage:\n ./salt.sh master \nOR\n ./salt.sh minion master-address\n"
      exit 1
}

if [ $# -eq 0 ]
  then
  show_help
fi

function install_salt() {
  curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
  curl -fsSL https://bootstrap.saltproject.io/sha256 -o install_salt_sha256

  # Verify file integrity
  SHA_OF_FILE=$(sha256sum install_salt.sh | cut -d' ' -f1)
  SHA_FOR_VALIDATION=$(cat install_salt_sha256)
  if [[ "$SHA_OF_FILE" == "$SHA_FOR_VALIDATION" ]]; then
      # After verification, run script to bootstrap master
      echo "Success! Installing..."
      if [[ "$1" == "master" ]]
      then
        sh install_salt.sh -P -M -x python3
        systemctl enable --now salt-master.service
      else
        sudo sh install_salt.sh -P -x python3
        sed -i "s/#master\:\ salt/master: $MASTER_IP/gm" /etc/salt/minion
        echo $HOSTNAME > /etc/salt/minion_id
        systemctl enable --now salt-minion.service
        systemctl restart salt-minion.service
      fi
  else
      # If hash check fails, don't attempt install
      echo "WARNING: This file is corrupt or has been tampered with."
  fi
}

if [[ "$1" == 'master' ]]
then
echo "Setting up master"
  install_salt master
else
  echo "Setting up minion"
  [ $# -eq 2 ] || (show_help && exit 1)
  MASTER_IP=$2
  install_salt master
fi
