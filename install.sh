#! /bin/bash
os=$(uname)

function checkInstall {
  package=$1
  command=$2

  echo -n "check: $command"

  if [ -x "$(command -v $command)" ]; then
    echo " - installed"
    return
  fi

  echo " - installing..."

  if [ "$os" = "Linux" ]; then
    sudo apt-get install $package
  elif [ "$os" = "Darwin" ]; then
    brew install $package
  fi
}

link_target=~/.config/nvim

if ! [ -e "$link_target" ]; then
  echo "create softlink from repo to config location"
  echo "(it's $link_target)"
  ln -s ~/.my_nvim/src $link_target
else
  echo "softlink from repo to config found"
  echo "(at $link_target)"
fi

echo "check / install dependencies"

if [ "$os" = "Linux" ]; then

  checkInstall "riprep" "rg"
  checkInstall "fd-find" "fdfind"

elif [ "$os" = "Darwin" ]; then
  
  if ! [ -x "$(command -v brew)" ]; then
    echo "brew missing and needed"
    return
  fi
  checkInstall "riprep" "rg"
  checkInstall "fd" "fd"

fi

echo "we good"
echo "start nvim and run :PackerSync"
echo "then run :checkhealth for further things to do"
