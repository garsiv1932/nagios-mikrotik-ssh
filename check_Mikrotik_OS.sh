#!/bin/bash
HOST="127.0.0.1"
CRITICAL=0
ADMIN="nagios"
while getopts "H:U:C" opt; do
  case $opt in
    H)
      HOST=$OPTARG
      ;;
    C)
      CRITICAL=1
      ;;
    U)
      USERNAME=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
OS=$(ssh -i /home/administrador/scripts/mikrotik/rsa/id_rsa.pem $ADMIN@$HOST 'system package update check-for-updates')
FW=$(echo "$OS" | grep "installed-version" | awk '{if(NR==1)print $2}' | tr -d \\r)
SW=$(echo "$OS" | grep "latest-version" | awk '{print $2}' | tr -d \\r)

if [ "$FW" == "$SW" ]; then
  echo "OK: Firmware versions match ($SW)"
  exit 0
else
  if [ $CRITICAL -gt 0 ]; then
    echo "CRITICAL: Software version $SW does not match firmware version $FW"
    exit 2
  else
    echo "WARNING: Software version $SW does not match firmware version $FW"
    exit 1
  fi
fi
