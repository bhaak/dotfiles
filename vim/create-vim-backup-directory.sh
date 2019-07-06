#!/bin/sh

umask 077
dir=$(date +%Y-%m-%dT%H:%M)

mkdir -p $HOME/.vimbackup/$dir >& /dev/null

rm -f $HOME/.vimbackup/backup >& /dev/null ; ln -s $HOME/.vimbackup/$dir $HOME/.vimbackup/backup

