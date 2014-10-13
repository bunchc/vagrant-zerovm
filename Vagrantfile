# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'ZeroVM'       => [1, 110],
}

$commonscript = <<COMMONSCRIPT
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install iftop iptraf vim curl wget lighttpd -y

sudo su -c 'echo "deb http://packages.zerovm.org/apt/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list' 
wget -O- http://packages.zerovm.org/apt/ubuntu/zerovm.pkg.key | sudo apt-key add - 

sudo apt-get update
sudo apt-get install -y zerovm zerovm-cli

wget http://packages.zerovm.org/zerovm-samples/python.tar 
echo 'print "Hello"' > hello.py

sudo apt-get install -y zerovm-dev gcc-4.4.3-zerovm
sudo apt-get install -y linux-headers-$(uname -r)

COMMONSCRIPT

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
                box.vm.provision :shell, inline: $commonscript

                # If using Fusion
                box.vm.provider :vmware_fusion do |v|
                    v.vmx["memsize"] = 1024
                end
            end
        end
    end
end