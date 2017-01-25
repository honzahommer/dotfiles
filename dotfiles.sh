for DOTFILE in \
  vars \
  prompt \
  aliases \
  keyboard \
  functions
do
  if [ -s "$DOTFILES_DIR/$DOTFILE.sh" ]; then
    . "$DOTFILES_DIR/$DOTFILE.sh"
  fi
done


