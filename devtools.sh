
./ZeroVM.sh

sudo apt-get install -y zerovm-dbg sudo apt-get install zerovm-dev

#Install ZeroVM GCC toolchain:
sudo apt-get -y install gcc-4.4.3-zerovm

#Install some build tools:
sudo apt-get -y install make automake autoconf git

#Install ZeroVM debugger (not for the faint of heart):
sudo apt-get -y install gdb-zerovm

#Now you can build some sample programs:
git clone https://github.com/zerovm/zerovm-samples
cd zerovm-samples
make