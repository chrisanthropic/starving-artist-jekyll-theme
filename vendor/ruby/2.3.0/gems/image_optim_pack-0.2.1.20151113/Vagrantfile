Vagrant.configure('2') do |config|
  {
    linux_i686: 'chef/centos-6.5-i386',
    linux_x86_64: 'chef/centos-6.5',
  }.each do |name, url|
    config.vm.define name do |machine|
      machine.vm.hostname = name.to_s.gsub('_', '-')
      machine.vm.box = url
    end
  end

  config.vm.provision :shell, path: 'script/vm_init'
end
