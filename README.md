Puppet configs for Socorro (RHEL in AWS)
----------------------------------------
Install:
::
  sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
  yum install puppet
  sudo mkdir -p /var/cache/puppet
  sudo cp -rp ./manifests ./files ./templates /var/cache/puppet
  sudo puppet resource package hiera ensure=installed
  sudo puppet resource package hiera-puppet ensure=installed
  sudo cp hiera.yaml /etc/puppet
  sudo cp common.yaml-dist /var/lib/hiera/common.yaml

Configure:
::
  sudo vi /etc/puppet/common.yaml

Run:
::
  sudo puppet apply /var/cache/puppet/manifests/init.pp
