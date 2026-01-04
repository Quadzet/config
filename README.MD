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
