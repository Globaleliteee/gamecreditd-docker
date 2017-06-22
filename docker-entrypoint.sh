#!/bin/sh
set -e
GAMECOIN_DATA=/home/gamecredits/.gamecredits

cd /home/gamecredits/gamecreditsd

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for gamecreditsd"

  set -- gamecreditsd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "gamecreditsd" ]; then
  mkdir -p "$GAMECOIN_DATA"
  chmod 700 "$GAMECOIN_DATA"
  chown -R gamecredits "$GAMECOIN_DATA"

  echo "$0: setting data directory to $GAMECOIN_DATA"

  set -- "$@" -datadir="$GAMECOIN_DATA"
fi

if [ "$1" = "gamecreditsd" ] || [ "$1" = "gamecredits-cli" ] || [ "$1" = "gamecredits-tx" ]; then
  echo
  exec gosu gamecredits "$@"
fi

echo
exec "$@"
