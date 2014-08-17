Vagrant.configure("2") do |config|
    config.vm.box = "ToguCMS"
    config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
    end    
    config.vm.network :private_network, ip: "192.168.33.10"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.synced_folder ".", "/vagrant", type: "nfs"
    config.vm.provision :shell, :path => "vagrant-provisioner.sh"
end
