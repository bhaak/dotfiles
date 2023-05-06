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
		echo -e "$okay" "adding $1 to crontab" "$reset"
		(crontab -l 2>/dev/null; echo "$1") | crontab -
	fi
}

function add_line_to_file()
{
	if ! grep -F "$2" "$1" >/dev/null; then
		echo -e "$okay" "adding $2 to $1" "$reset"
		echo >> "$1" "$2"
	fi
}

link dunst/dunstrc .config/dunst/dunstrc
link misc/xmodmap .xmodmap
link misc/ydl bin/ydl
link misc/dff bin/dff

link mpv/input.conf .config/mpv/input.conf

link git/gitconfig .gitconfig
link git/gitattributes .gitattributes
link git/git-rename-branch   bin/git-rename-branch
link git/git-checkout-branch bin/git-checkout-branch 

link shells/bash_aliases .bash_aliases
link shells/bashrc_common .bashrc_common
mkdir -p "$HOME/.logs"
add_line_to_file "$HOME/.bashrc" "test -e \"$HOME/.bashrc_common\" && . \"$HOME/.bashrc_common\""
add_line_to_file "$HOME/.bashrc" "test -e \"$HOME/.bashrc_local\" && . \"$HOME/.bashrc_local\""

mkdir -p "$HOME/.vim/swap_files"
mkdir -p "$HOME/.vim/undo_files"
mkdir -p "$HOME/.vim/autoload/"
link vim/vimrc .vimrc
link vim/neovim_init.vim .config/nvim/init.vim
link vim/vim-plug.vim .vim/autoload/plug.vim
link vim/create-vim-backup-directory.sh bin/create-vim-backup-directory.sh
add_to_crontab "*/10 * * * * $HOME/bin/create-vim-backup-directory.sh"
