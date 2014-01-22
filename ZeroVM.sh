export DEBIAN_FRONTEND=noninteractive

# Setup our repo's
sudo apt-get update
sudo apt-get install iftop iptraf vim curl wget lighttpd -y

# ZeroVM Bits
sudo su -c 'echo "deb [ arch=amd64 ] http://zvm.rackspace.com/v1/repo/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list' 
wget -O- https://zvm.rackspace.com/v1/repo/ubuntu/zerovm.pkg.key | sudo apt-key add - 
sudo apt-get update

sudo apt-get -y install zerovm-udt
sudo apt-get -y install zerovm-cli