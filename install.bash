#!/bin/bash

echo "Initializing submodules..."
git submodule update --init --recursive

echo "Adding aliases..."
cat .bash_aliases >> $HOME/.bash_aliases

(cd stderred && make) || exit 1

echo "Configuring .bashrc"
cat <<EOF >> $HOME/.bashrc
[[ \$TERM =~ '256color' ]] && [ -f ~/prompt.sh ] && source ~/prompt.sh

export LD_PRELOAD="$HOME/dotfiles/stderred/build/libstderred.so\${LS_PRELOAD:+:\$LD_PRELOAD}"
export STDERRED_ESC_CODE=\$(printf "\\e[38;2;255;85;85m")
EOF

(cd fzf && ./install.bash) || exit 1

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
