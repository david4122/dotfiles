#!/bin/bash

echo "Initializing submodules..."
git submodule update --init --recursive

rmdir $HOME/dotfiles_backup 2>/dev/null
mkdir $HOME/dotfiles_backup || exit 1
files=(.vimrc .fzf.bash .tmux.conf .vim .tmux)
for file in ${files[@]}; do
	if [ -f $HOME/$file ]; then
		echo "Backing up $file.."
		mv $HOME/$file $HOME/dotfiles_backup/$file
	fi

	echo "Linking $file..."
	ln -s $(pwd)/$file $HOME
done

rmdir $HOME/dotfiles_backup 2>/dev/null

echo "Adding aliases..."
cat .bash_aliases >> $HOME/.bash_aliases

echo "Configuring .bashrc"
cat <<SH >> $HOME/.bashrc
[[ \$TERM =~ '256color' ]] && [ -f ~/prompt.sh ] && source ~/prompt.sh
SH
