$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF
export VG_DOCKER_USER=#{ENV['EVG_DOCKER_USER']}
export VG_DOCKER_PSWD=#{ENV['EVG_DOCKER_PSWD']}
export VG_DOCKER_DOMAIN=#{ENV['EVG_DOCKER_DOMAIN']}

EOF
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.network :private_network, type: "dhcp"
    config.vm.network :public_network, bridge: "#{ENV['EVG_ADAPTR_BRIDGE']}"
    config.vm.synced_folder "share/", "/home/vagrant/share", type: "nfs"
 
    config.vm.provision "shell", inline: $set_environment_variables, run: "always"

    config.vm.provision :shell, path: "./install.sh"
    
    config.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 1
    end
end