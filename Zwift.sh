export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install screen vim curl wget git -y

git clone https://github.com/ludditry/design-summit.git /opt/design-summit

sudo chmod +x /opt/design-summit/configuration/zwift-aio/bootstrap.sh
sudo /opt/design-summit/configuration/zwift-aio/bootstrap.sh