#!/bin/bash -xe

cd /tmp/

url=`curl -s https://www.ruby-lang.org/en/downloads/ | grep cache.ruby-lang | cut -f 2 -d \" | head -1`

echo $url
curl -O $url

filename=`echo $url | rev | cut -f 1 -d / | rev`
echo $filename
tar xf $filename

base=`basename $filename .tar.gz`
cd $base
echo $pwd

./configure --prefix=$HOME/.rubies/$base && make -j10 && make install
