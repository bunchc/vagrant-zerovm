# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'ZeroVM'    => [1, 110],
    'ZeroCloud' => [1, 120],
}

$zerovm = <<ZEROVM
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install iftop iptraf vim curl wget lighttpd software-properties-common python-software-properties -y

sudo apt-add-repository ppa:zerovm-ci/zerovm-latest

sudo apt-get update
sudo apt-get install -y zerovm zerovm-cli

echo "*** Installing Dev Environment ***"
sudo apt-get install -y zerovm-dev gcc-4.4.3-zerovm
sudo apt-get install -y linux-headers-$(uname -r)

echo "*** Downloading Python ***"
wget http://packages.zerovm.org/zerovm-samples/python.tar 
echo 'print "Hello"' > hello.py

echo "*** Preparing for Channel Size Example ***"
dd if=/dev/urandom of=/home/vagrant/file.txt bs=1048576 count=100

cat > /home/vagrant/example.py <<EOF
file = open('/dev/3.file.txt', 'r')
print file.read(5)
EOF

su - vagrant -c "zvsh --zvm-save-dir ~/ --zvm-image python.tar --zvm-image ~/file.txt python @example.py"
sudo sed -i "s|Channel = /home/vagrant/file.txt,/dev/3.file.txt,3,0,4294967296,4294967296,0,0|Channel = /home/vagrant/file.txt,/dev/3.file.txt,3,0,3,3,3,3|g" /home/vagrant/manifest.1
sudo sed -i "s|/home/vagrant/stdout.1|/dev/stdout|g" /home/vagrant/manifest.1
sudo sed -i "s|/home/vagrant/stderr.1|/dev/stderr|g" /home/vagrant/manifest.1

chown -R vagrant:vagrant /home/vagrant
ZEROVM

$zerocloud = <<ZEROCLOUD
export DEBIAN_FRONTEND=noninteractive

# Setup Repos
sudo apt-get update
sudo apt-get install iftop iptraf vim curl wget lighttpd software-properties-common python-software-properties -y
sudo apt-add-repository ppa:zerovm-ci/zerovm-latest
sudo apt-get update

# Git over https
cat >> ~/.gitconfig <<EOF
[url "https://github"]
        insteadOf = git://github
[url "https://git.openstack"]
    insteadOf = git://git.openstack
EOF

# Download Devstack
adduser --disabled-password --gecos "" stack
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
git clone https://github.com/openstack-dev/devstack.git -b stable/icehouse /home/stack/devstack/
git clone https://github.com/openstack/heat-templates.git /home/stack/heat-templates/

# Packages for ZeroCloud
sudo apt-get install git python-pip zerovm --yes --force-yes
sudo pip install python-swiftclient==2.2.0
sudo pip install python-keystoneclient

###
# Swauth: Auth middleware for Swift
git clone https://github.com/gholt/swauth.git /home/stack/swauth
cd /home/stack/swauth
git checkout tags/1.0.8
sudo python setup.py install

###
# ZeroCloud: ZeroVM middleware for Swift
# Install is from the code on the host, mapped to /zerocloud
cd /zerocloud-root
sudo python setup.py develop

###
# Python system image for ZeroCloud/ZeroVM
sudo mkdir /usr/share/zerovm
cd /usr/share/zerovm
sudo wget -q http://packages.zerovm.org/zerovm-samples/python.tar

# Setup for Devstack
echo "
ADMIN_PASSWORD=admin
HOST_IP=127.0.0.1
disable_all_services
enable_service mysql s-proxy s-object s-container s-account
# Commit 034fae630cfd652093ef53164a7f9f43bde67336 in Swift
# breaks ZeroCloud, completely and utterly.
# The previous commit works:
SWIFT_BRANCH=ca915156fb2ce4fe4356f54fb2cee7bd01185af5
KEYSTONE_BRANCH=2fc25ff9bb2480d04acae60c24079324d4abe3b0

# Output
LOGFILE=/opt/stack/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=False
SCREEN_LOGDIR=/opt/stack/logs
" | tee -a /home/stack/devstack/local.conf

cat >> /home/stack/devstack/extras.d/89-zerocloud.sh <<EOF
if [[ "\$1" == "stack" && "\$2" == "post-config" ]]; then
    echo_summary "Configuring ZeroCloud middleware for Swift"
    python /vagrant/configure_swift.py
fi
EOF
 
chown -vR stack:stack /home/stack

ZEROCLOUD

Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/precise64"
    config.vm.synced_folder ".", "/vagrant", nfs: true

    #Default is 2200..something, but port 2200 is used by forescout NAC agent.
    config.vm.usable_port_range= 2800..2900 

    nodes.each do |prefix, (count, ip_start)|
        count.times do |i|
            #hostname = "%s-%02d" % [prefix, (i+1)]
            hostname = "%s" % [prefix, (i+1)]

            config.vm.define "#{hostname}" do |box|
                box.vm.hostname = "#{hostname}.cook.book"
                box.vm.network :private_network, ip: "172.16.0.#{ip_start+i}", :netmask => "255.255.0.0"
                if prefix == "ZeroVM"
                    box.vm.provision :shell, inline: $zerovm
                elsif prefix == "ZeroCloud"
                    box.vm.provision :shell, inline: $zerocloud
                end
                # If using Fusion
                box.vm.provider :vmware_fusion do |v|
                    v.vmx["memsize"] = 1024
                end
            end
        end
    end
end
