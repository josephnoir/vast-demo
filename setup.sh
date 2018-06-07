#!/bin/bash

export CXX=/usr/local/opt/llvm/bin/clang++
export LDFLAGS=$(/usr/local/opt/llvm/bin/llvm-config --ldflags)

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cores=4
if [ "$(uname)" == "Darwin" ]; then
  cores=$(sysctl -n hw.ncpu)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  cores=$(nproc --all)
fi

echo "Using $cores cores for compilation."

echo "Building CAF"
if cd actor-framework
then
  echo "CAF already exists"
else
  git clone https://github.com/actor-framework/actor-framework.git
  cd $ROOT_DIR/actor-framework
  git checkout cdfe2c22
  ./configure --no-opencl --no-tools --no-examples --build-type=release
  make -j$cores
fi
cd $ROOT_DIR

echo "Building VAST"
if cd vast
then
  echo "VAST already exists"
else
  git clone https://github.com/vast-io/vast.git
  cd $ROOT_DIR/vast
  git checkout 2b761725
  ./configure --build-type=release --with-caf=$ROOT_DIR/actor-framework/build/
  make -j$cores
fi
cd $ROOT_DIR

echo "Building Bro Aux tools"
BRO_FOLDER=bro-aux-0.39
BRO_FILE=$BRO_FOLDER.tar.gz
if cd $BRO_FOLDER
then
  echo "Looks like bro tools already exist"
else
  curl -O https://www.bro.org/downloads/$BRO_FILE
  tar xzf $BRO_FILE
  cd $BRO_FOLDER
  ./configure
  make
fi
cd $ROOT_DIR
rm -f $BRO_FILE

echo "Downloading BGP updates"
if cd bgp
then
  echo "bgp already downloaded?"
else
  mkdir bgp
  ./bgp_download_routeviews_all_updates.sh
fi
cd $ROOT_DIR

echo "Downloading conn logs"
if cd honeypot
then
  echo "honeypot data already downloaded"
else
  mkdir honeypot
  cd $ROOT_DIR/honeypot
  scp localadmin@mobi7.inet.haw-hamburg.de:/users/localadmin/persistent_vast/bmbf-demo/honeypot/* ./
fi
cd $ROOT_DIR

echo "Downloading intelmq logs"
if cd intelmq
then
  echo "intelmq data already downloaded"
else
  mkdir intelmq
  cd $ROOT_DIR/intelmq
  scp localadmin@mobi7.inet.haw-hamburg.de:/users/localadmin/persistent_vast/bmbf-demo/intelmq/* ./
fi
cd $ROOT_DIR

echo "DONE"
echo "please 'export PATH=\$PATH:$ROOT_DIR/vast/build/bin:$ROOT_DIR/bro-aux-0.39/build/bro-cut'"
