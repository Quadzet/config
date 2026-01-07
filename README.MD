## What is this?
Some of my personal settings and scripts, intended for Arch Linux.
There is also an outdated script to install them on windows 11.

## Setup
Move `.bashrc` to `~/`
Move all directories into `~/.config/`

## Info
Neovim uses vim's config (`_vimrc`) as a baseline for key
mappings and basic settings. It then adds Rich Language Features
such as LSP's, linters/formatters and other plugins in it's
own config in `nvim/init.lua` and `nvim/lua/*`.

Vim requires the `.bashrc` to source from the correct directory
(`~/.config/vim`) instead of the default (`~/`).

The git config has some personal settings but is generally
just for minor conveniences such as aliases.

## TODO
  - Make package specific script that eg installs minpack for vim
  - Add npm installation for neovim (required by Mason)
      sudo pacman -S nodejs npm
      sudo pacman -S python python-pip
      sudo pacman -S unzip
  - cert setup for npm
      npm config set noproxy .sebank.se
      npm config set registry https://repo7.sebank.se/artifactory/api/npm/seb-npm
      npm config set https-proxy http://wss.sebank.se:80
      npm config set proxy http://wss.sebank.se:80
      npm config set cafile /etc/ssl/certs/ca-certificates.crt
  - Install the CA bundle
      sudo cp /mnt/c/users/S2304G/Downloads/SEB_CA_Certs.pem /etc/ca-certificates/trust-source/anchors/
      in .bashrc: export NODE_EXTRA_CA_CERTS=/etc/ca-certificates/trust-source/anchors/SEB_CA_Certs.pem
      sudo update-ca-trust
