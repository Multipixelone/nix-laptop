<h1 align="center">finns ❄️ dots</h1>

[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![GitHub Language](https://img.shields.io/github/languages/top/Multipixelone/nix-laptop?color=c6a0f6)
[![CI](https://github.com/Multipixelone/nix-laptop/actions/workflows/ci.yml/badge.svg)](https://github.com/Multipixelone/nix-laptop/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/Multipixelone/nix-laptop)](https://github.com/Multipixelone/nix-laptop/blob/master/LICENSE)

## About

this used to be my temporary flake just for setting up my laptop but my old flake had such poor code quality that this became my default one.

this repo is absolutely **screaming** for a refactor and for a lot of the code to be reorganized and probably an addition of `flake-parts`. a lot of the machine detecting logic was poorly written and written before I realized how to be cognizant and write my own modules. Theres a lot of hardcoded `lib.mkIf` statements that check `config.networking.hostname` or `osConfig.networking.hostname` that are just _so_ heinous and terribly unscalable. I keep putting off the refactor so don't look at this flake for anything other then some weird solutions I've came up with.

once I get around to this, it will be a glorious day indeed.

## Things I Think Are Cool

- secrets are managed in a private repo and decrypted at runtime by `agenix`
- restic backups to **OneDrive**
- packages are built in a Github Action and pushed to an attic server running on **fly.io**
- music syncing between computers and a script to download my playlists on a timer
