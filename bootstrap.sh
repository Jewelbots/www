brew install coreutils
brew install findutils
brew install nginx
brew install yuicompressor
cp ./nginx.conf /usr/local/etc/nginx

mkdir /var/src/
sudo chown -R $(whoami) /var/src/
sudo chmod 777 ./build.sh
