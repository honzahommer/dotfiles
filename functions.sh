#!/usr/bin/env bash

# Generate random string
function random {
  echo "`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1`"
}

# Get number of CPU cores
function hwinfo {
  cat /proc/${1:-cpu}info
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
  command -v "$1"
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
function extract {
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

# CD into cloned directory
function clone {
  git clone "$1" "${2:-$HOME/Projects/}`echo $1 | awk -F"/" '$0=tolower($0) {print $(NF-1)"/"$NF}' | awk -F"." '{print $1}'`" && cd "$_"
}

# Make from repo or archive
function mk {
  mcd "/tmp/`random`/"
  case "$1" in
    *.git)
      clone "$1" "$PWD/"
    ;;
    *)
      wget -nv -q "$1" && \
      extract *.* 2> /dev/null
      cd *
    ;;
  esac
  [ -f ./configure ] && \
    ./configure "${@:2}"
  [ -f ./Makefile ] && \
    sudo make -j "`cpus`" && \
    sudo make install
  cd "$MCD"
}

# Get IP hostnames
function ipinfo {
  geoip "$1"
  nmap -sL "$@" | grep "Nmap scan report.*(" | awk '{print "  "substr($6, 2, length($6) - 2)"\thttp://"$5}'
}

# GeoIP
function geoip {
  echo -e "  $1\t`geoiplookup -f /usr/share/GeoIP/GeoLiteCity.dat ${1%/*} | grep -v "not found" | awk -F": " '{print $2}'`"
}

# Run script from URL
function run {
  case $2 in
  bash|sh)
    LANG="$2"
    ARGS="${@:3}"
  ;;
  *)
    LANG="bash"
    ARGS="${@:2}"
  esac

  wget -qO- "$1" | tr -d "\r" | ${LANG} -s -- ${ARGS}
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
  cat `home ${1}`/.ssh/*.pub | copy
}

# Copy private key to clipboard
function privkey {
  read -p "Are you sure? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cat `home ${1}`/.ssh/id_rsa | copy
  fi
}

# Funny commit message
function commit {
  MSG[0]="This is where it all begins..."
  MSG[1]="Commit committed"
  MSG[2]="Version control is awful"
  MSG[3]="COMMIT ALL THE FILES!"
  MSG[4]="The same thing we do every night, Pinky - try to take over the world!"
  MSG[5]="Lock S-foils in attack position"
  MSG[6]="This commit is a lie"
  MSG[7]="I'll explain when you're older!"
  MSG[8]="Here be Dragons"
  MSG[9]="Reinventing the wheel. Again."
  MSG[10]="This is not the commit message you are looking for"
  MSG[11]="Batman! (this commit has no parents)"
  RND=$[ $RANDOM % 11 ]

  if [ ! -d ".git" ]; then
    git init
  fi

  git add .
  git commit -m"`echo ${MSG[$RND]}`"
}

function skeleton {
  wget -qO- https://raw.githubusercontent.com/honzahommer/skeleton/master/bin/install | \
    DEBIAN_FRONTEND=noninteractive \
    SITENAME="${1}" \
    HOSTNAME="localhost" \
    bash
}

function upd {
  read -p "Are you sure? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get -y update
    apt-get -y dist-upgrade
  else
    echo
    echo "Aborted..."
  fi
}
