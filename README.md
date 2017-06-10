# Dotfiles

## Installation

```sh
git clone https://github.com/honzahommer/dotfiles.git $HOME/.dotfiles

cat <<EOT >> $HOME/.bashrc
export DOTFILES_DIR="\$HOME/.dotfiles"
[ -s "\$DOTFILES_DIR/dotfiles.sh" ] && . "\$DOTFILES_DIR/dotfiles.sh"  # This loads dotfiles
EOT
```

