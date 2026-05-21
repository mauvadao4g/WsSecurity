#!/usr/bin/env bash
ARCH=$(uname -m)
case "$ARCH" in
  x86_64|i386|i686)
    PROXY_BIN="./dragon_go-x86"
    ;;
  aarch64|armv7l|armv6l|arm*)
    PROXY_BIN="./dragon_go-ARM"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

read -p "Enter proxy port (e.g. 80 or 443): " PORT
SESSION="proxy_${PORT}"

read -p "Action (start/stop): " ACTION

case "$ACTION" in
  start)
    screen -dmS "$SESSION" "$PROXY_BIN" -port ":${PORT}"
    echo "→ Started proxy on port ${PORT} in screen session '${SESSION}'."
    ;;

  stop)
    screen -S "$SESSION" -X quit
    echo "→ Stopped proxy on port ${PORT} (session '${SESSION}' closed)."
    ;;

  *)
    echo "Invalid action. Please run the script and enter 'start' or 'stop'."
    exit 1
    ;;
esac
