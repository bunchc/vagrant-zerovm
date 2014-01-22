export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install screen vim curl wget git -y

git clone https://github.com/rpedde/zwift-aio.git /opt/zwift-aio

sudo chmod +x /opt/zwift-aio/*
sudo /opt/zwift-aio/bootstrap.sh
sudo /opt/zwift-aio/rescreen.sh