#!/bin/bash -e

echo "Linking files..."
BASEDIR="$(cd "$(dirname $0)" && pwd)"

function link()
{
	SOURCE=$1
	DEST=$2
	error="\e[31m"
	okay="\e[32m"

	echo -n "Linking '$SOURCE' to '$HOME/$DEST' ... "
	if [[ -f "$HOME/$DEST" ]]; then
		echo -e "$error" "exists already"
	else
		ln "$BASEDIR/$SOURCE" "$HOME/$DEST"
		echo -e "$okay" "linked"
	fi
}

link misc/xmodmap .xmodmap
