export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install screen vim curl wget git -y

git clone https://github.com/bunchc/design-summit.git -b "apacheFixes" /opt/design-summit

sudo chmod +x /opt/design-summit/zwift-aio/bootstrap.sh
sudo /opt/design-summit/zwift-aio/bootstrap.sh