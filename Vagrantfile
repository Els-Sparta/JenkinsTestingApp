# Install required plugins
# Include plugin for "vagrant-berkshelf"
required_plugins = ["vagrant-berkshelf", "vagrant-ghost"]
required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      puts "installing vagrant plugin #{plugin}"
      Vagrant::Plugin::Manager.instance.install_plugin plugin
      puts "installed vagrant plugin #{plugin}"
    end
end

def set_env vars
  command = <<~HEREDOC
      echo "Setting Environment Variables"
      source ~/.bashrc
  HEREDOC

  vars.each do |key, value|
    command += <<~HEREDOC
      if [ -z "$#{key}" ]; then
          echo "export #{key}=#{value}" >> ~/.bashrc
      fi
    HEREDOC
  end

  return command
end

Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.network "private_network", ip: "192.168.10.100"
    app.ghost.hosts = ["development.local"]
    app.vm.synced_folder "app", "/home/ubuntu/app"
    app.vm.synced_folder "environment/app", "/home/ubuntu/environment"
    app.vm.provision "chef_solo" do |chef|
      chef.add_recipe "node-server::default"
    end
    app.vm.provision "shell", inline: set_env({ DB_HOST: "mongodb://192.168.10.150:27017/posts" }), privileged: false
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.ghost.hosts = ["database.local"]
    db.vm.synced_folder "environment/db", "/home/ubuntu/environment"
    db.vm.provision "chef_solo" do |chef|
      chef.add_recipe "mongo-server::default"
    end
  end
end
