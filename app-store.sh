#!/bin/bash
# pi-app-store: 1
# pi-app-store-category: apps
set -eu
package=nnn
program=nnn
installed() { command -v dpkg-query >/dev/null && [ "$(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true)" = 'install ok installed' ] && command -v "$program" >/dev/null; }
case "${1:-status}" in
 status) if installed; then printf '%s is installed\n' "$package"; else printf '%s is not installed\n' "$package"; exit 1; fi ;;
 install)
  if installed; then echo "$package is already installed. Nothing changed."; exit 0; fi
  [ "$(id -u)" -eq 0 ] || { echo 'Install needs root. Run the Store with sudo.'; exit 1; }
  command -v apt-get >/dev/null || { echo 'A Debian/DietPi apt system is required.'; exit 1; }
  apt-get update
  candidate=$(apt-cache policy "$package" | awk '/Candidate:/{print $2;exit}')
  [ -n "$candidate" ] && [ "$candidate" != '(none)' ] || { echo 'No package candidate in configured repositories. Nothing installed.'; exit 1; }
  apt-get install -y -- "$package"
  installed || { echo 'Package installed but executable not found. Check PATH (including /usr/games).'; exit 1; }
  ;;
 run)
  installed || { echo 'Install the package first. Ensure /usr/games is on PATH for games.'; exit 1; }
  [ -t 0 ] && [ -t 1 ] || { echo 'This app needs an interactive terminal. Use Run in terminal.'; exit 1; }
  if [ "$(id -u)" -eq 0 ]; then
   user=${SUDO_USER:-}
   [ -n "$user" ] && [ "$user" != root ] && id "$user" >/dev/null 2>&1 || { echo "Do not run this app as root. Log into your regular account and run $program."; exit 1; }
   home=$(getent passwd "$user" | cut -d: -f6)
   [ -d "$home" ] || { echo 'Regular user home is unavailable.'; exit 1; }
   cd "$home"
   exec runuser -u "$user" -- env HOME="$home" "$program"
  fi
  cd "$HOME"
  exec "$program"
  ;;
 *) echo 'Use: bash app-store.sh status|install|run'; exit 2 ;;
esac
