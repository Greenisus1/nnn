# nnn - Pi App Store package wrapper

A small terminal file manager. Upstream project: https://github.com/jarun/nnn. The upstream software is not written by Greenisus1; its license is BSD-2-Clause. This repository contains only a small package-manager wrapper, not a copy or fork of upstream source. Debian packages carry their upstream notices in /usr/share/doc/nnn/copyright.

## Use

This appears with the existing Apps in Pi App Store. The Store reviews this complete wrapper and asks before running it.

- `bash app-store.sh status` detects the package and executable, including packages installed outside the Store.
- `bash app-store.sh install` uses configured apt repositories and checks for a candidate before installing. If already installed, nothing changes.
- `bash app-store.sh run` needs an interactive terminal. Runs as your regular sudo caller, never silently as root. If logged in as root without a sudo caller, log into a regular account and run the executable directly.

No upstream quickstart script, plugin installer, source download, service, startup hook or setuid/capability setting is added. Apt may install dependencies. Removing this Store checkout does not remove the system package. Distro-package updates are managed through apt, not this wrapper version.

Tested: wrapper shell checks and isolated mocked Debian command flows on Linux. Official Debian trixie arm64 package availability checked. Not yet tested on a Raspberry Pi or other operating systems. The actual package version/availability depends on your configured apt sources.

Wrapper code: MIT, copyright 2026 Greenisus1. Upstream retains its own license and credits.
