#!/bin/bash -xe

cd /tmp/

url=`curl -s https://www.jruby.org/download | grep Binary | cut -f 2 -d \' | head -1`

echo $url

curl -O $url

filename=`echo $url | rev | cut -f 1 -d / | rev`

echo $filename

tar xf $filename

base=`echo $filename | cut -f 1,3 -d -`

mv $base $HOME/.rubies/$base
