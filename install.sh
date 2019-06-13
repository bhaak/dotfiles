#!/bin/bash -e

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

link dunst/dunstrc .config/dunst/dunstrc
link misc/xmodmap .xmodmap

link git/gitconfig .gitconfig
link git/git-rename-branch bin/git-rename-branch
