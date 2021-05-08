#!/bin/bash -e

git submodule init && git submodule update

echo "Linking files..."
BASEDIR="$(cd "$(dirname $0)" && pwd)"
mkdir -p "$HOME/bin"

function link()
{
	SOURCE=$1
	DEST=$2
	DESTDIR=$(dirname "$DEST")
	error="\033[31m"
	okay="\033[32m"
	reset="\033[0m"

	if [[ ! -d "$HOME/$DESTDIR" ]]; then
		mkdir -p "$HOME/$DESTDIR"
	fi

	echo -n "Linking '$SOURCE' to '$HOME/$DEST' ... "
	if [[ -f "$HOME/$DEST" ]]; then
		echo -e "$error" "exists already" "$reset"
	else
		ln "$BASEDIR/$SOURCE" "$HOME/$DEST"
		echo -e "$okay" "linked" "$reset"
	fi
}

function add_to_crontab()
{
	if ! crontab -l | grep -F "$1" >/dev/null; then
		echo -e "$okay" "adding $1 to crontab"
		(crontab -l 2>/dev/null; echo "$1") | crontab -
	fi
}

link dunst/dunstrc .config/dunst/dunstrc
link misc/xmodmap .xmodmap
link misc/ydl bin/ydl
link misc/dff bin/dff

link git/gitconfig .gitconfig
link git/git-rename-branch   bin/git-rename-branch
link git/git-checkout-branch bin/git-checkout-branch 

mkdir -p "$HOME/.vim/swap_files"
mkdir -p "$HOME/.vim/undo_files"
link vim/vimrc .vimrc
link vim/create-vim-backup-directory.sh bin/create-vim-backup-directory.sh
add_to_crontab "*/10 * * * * $HOME/bin/create-vim-backup-directory.sh"
