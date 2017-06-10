#!/usr/bin/env bash

# Generate random string
function rnd {
  echo "`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1`"
}

# Edit .dotfile
function dot {
  local dotfile="$DOTFILES_DIR/${1:-functions}.sh"
  if [ -f "$dotfile" ]; then
    editor "$dotfile" && \
    . "$dotfile"
    > "$HOME/.sshrc"
    for DOTFILE in \
      vars \
      prompt \
      aliases \
      functions
    do
      if [ -s "$DOTFILES_DIR/$DOTFILE.sh" ]; then
        cat "$DOTFILES_DIR/$DOTFILE.sh" >> "$HOME/.sshrc"
      fi
    done
  else
    echo "$1 not found!"
  fi
}

# Check if command (program) exists
function has {
  type "$1" > /dev/null 2>&1
}

# Quick file backup
function bak {
  cp -r "$1"{,.bak-`date +%Y%m%d%H%M%S`}
}

# Change working directory and list files
function cdl {
  cd "$@" && ls
}

# Create a new directory and enter it
function mcd {
  export MCD="$PWD"
  mkdir -p "$@" && cd "$_";
}

# Extra many types of compressed packages
function ext {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

# My public IP
function myip {
  local HOSTNAME=`hostname -f`
  for IPv in 4 6
  do
    local IP=`wget -${IPv}qO- icanhazip.com 2>/dev/null`
    [ ! -z "$IP" ] && echo "${HOSTNAME} has IPv${IPv} address ${IP}"
  done
}

# Get user home directory
function home {
  eval echo "~${1:-`whoami`}"
}

# Copy public key to clipboard
function pubkey {
  cat `home ${2}`/.ssh/*_${1:-rsa}.pub | copy
}

# Copy private key to clipboard
function privkey {
  read -p "Are you sure? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cat `home ${2}`/.ssh/id_${1:-rsa} | copy
  fi
}

# Funny commit message
function smb {
  local hostname
  local username
  local mountdir
  local shares
  local share

  for file in ~/.config/samba/${2:-*}; do
    source ${file}

    [ -z "${hostname}" ] && \
      hostname=`basename ${file}`

    mountdir=/home/${USER}/mnt/${hostname}/${share}

    for share in ${shares}; do
      if mount | grep -q ${mountdir}; then
        sudo umount ${mountdir}
      fi
    done

    case $1 in
      mount)
        for share in ${shares}; do
          mkdir -p ${mountdir}
          sudo mount -t cifs //${hostname}/${share} ${mountdir} -o credentials=${file},noexec
        done
        ;;
    esac
  done
}
