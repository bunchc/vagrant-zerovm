# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'ZeroVM'       => [1, 110],
    'Zwift'        => [1, 111],
}

Vagrant.configure("2") do |config|
    config.vm.box = "precise64"
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
                box.vm.provision :shell, :path => "#{prefix}.sh"

                # If using Fusion
                box.vm.provider :vmware_fusion do |v|
                    v.vmx["memsize"] = 1024
                end
            end
        end
    end
end
