#!/bin/bash -e

echo "Linking files..."
BASEDIR="$(cd "$(dirname $0)" && pwd)"

function link()
{
	SOURCE=$1
	DEST=$2
	DESTDIR=$(dirname "$DEST")
	error="\e[31m"
	okay="\e[32m"
	reset="\e[0m"

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
