#!/bin/bash -xe

cd /tmp/

if [ -n "$1" ]; then
  url=https://cache.ruby-lang.org/pub/ruby/$(echo "$1" | cut -f 1,2 -d .)/ruby-$1.tar.gz
else
  url=`curl -s https://www.ruby-lang.org/en/downloads/ | grep cache.ruby-lang | cut -f 2 -d \" | head -1`
fi

echo $url
curl -O $url

filename=`echo $url | rev | cut -f 1 -d / | rev`
echo $filename
tar xf $filename

base=`basename $filename .tar.gz`
cd $base
echo $pwd

./configure --prefix=$HOME/.rubies/$base && make -j10 && make install
