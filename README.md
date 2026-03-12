<h1 align="center">finns ❄️ dots</h1>

[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
[![CI](https://github.com/Multipixelone/infra/actions/workflows/check.yaml/badge.svg)](https://github.com/Multipixelone/infra/actions/workflows/ci.yml)
![GitHub Language](https://img.shields.io/github/languages/top/Multipixelone/infra?color=c6a0f6)
![GitHub Code Size](https://img.shields.io/github/languages/code-size/Multipixelone/infra?color=fab387)
[![License](https://img.shields.io/github/license/Multipixelone/infra?color=a6e3a1)](https://github.com/Multipixelone/infra/blob/master/LICENSE)

## About

We won!! It's finally [dendritic](https://github.com/mightyiam/dendritic)!! Everything is beautiful and is all modules built on top of flake-parts. Each file is a top level flake-parts module that is imported by import-tree.

## Things I Think Are Cool

- secrets are managed in a private repo and decrypted at runtime by `agenix`
- restic backups to **OneDrive**
- packages are built in a Github Action and pushed to an attic server running on **fly.io**
- music syncing between computers and a script to download my playlists on a timer
