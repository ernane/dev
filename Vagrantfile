VAGRANTFILE_API_VERSION = "2"

machines = [
  { hostname: "homologacao", ip: "192.168.33.10", memory: "512", box: "ubuntu/trusty64" }
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  machines.each do |machine|
    config.vm.define machine[:hostname] do |machine_config|

      machine_config.vm.box      = machine[:box]
      machine_config.vm.hostname = machine[:hostname]
      machine_config.vm.network "private_network", ip: machine[:ip]

      machine_config.vm.provider "virtualbox" do |vb|
        vb.customize [ "modifyvm", :id, "--name", machine[:hostname], "--memory", machine[:memory]]
      end

      machine_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path    = "puppet/modules"
        puppet.manifest_file  = "#{machine[:hostname]}.pp"
      end

    end
  end
end
