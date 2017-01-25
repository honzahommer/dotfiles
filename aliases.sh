# Allow aliases to be sudoed
alias sudo="sudo "

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Listing aliases
alias ls='LC_ALL=C ls --color=auto --group-directories-first -a'
alias ll='ls -l'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Packages
alias apt="sudo apt"
alias apt-get="sudo apt-get"
alias update="apt-get -qy update"
alias upgrade="apt-get -y dist-upgrade"
alias install="apt-get install"
alias remove="apt-get remove"
alias search="apt-cache search"
alias service="sudo service"
alias snap="sudo snap"

# Easily re-execute the last history command.
alias r="fc -s"

# Clear
alias c="clear"

# Copy & Paste
if which xsel >/dev/null; then
  alias copy="xsel --clipboard --input"
  alias paste="xsel --clipboard --output"
fi

# SSHrc
#if which sshrc >/dev/null; then
#  alias ssh="sshrc"
#fi
