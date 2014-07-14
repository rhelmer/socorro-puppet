# Set up basic Socorro requirements.
class webapp::socorro {

  service {

    'nginx':
      ensure  => running,
      enable  => true,
      require => [
        Package['nginx'],
        File['socorro_nginx.conf'],
      ];

    'memcached':
      ensure  => running,
      enable  => true,
      require => Package['memcached'];

    'rabbitmq-server':
      ensure  => running,
      enable  => true,
      require => Package['rabbitmq-server'];

    'elasticsearch':
      ensure  => running,
      enable  => true,
      require => Package['elasticsearch'];

    'supervisord':
      ensure  => running,
      enable  => true,
      require => Package['supervisor'];
  }

  yumrepo {
    'EPEL':
      baseurl  => 'http://dl.fedoraproject.org/pub/epel/$releasever/$basearch',
      descr    => 'EPEL',
      enabled  => 1,
      gpgcheck => 0,
      timeout  => 60;

    'elasticsearch':
      baseurl  => 'http://packages.elasticsearch.org/elasticsearch/0.90/centos',
      enabled  => 1,
      gpgcheck => 0;

    'supervisor':
      baseurl => 'http://repos.fedorapeople.org/repos/rmarko/supervisor/epel-6/noarch/',
      enabled  => 1,
      gpgcheck => 0,
  }

  package {
    [
      'git',
      'java-1.7.0-openjdk',
      'nginx',
      'memcached',
      'daemonize',
      'unzip',
    ]:
    ensure => latest
  }

  package {
    [
      'python-virtualenv',
      'rabbitmq-server',
      'python-pip',
      'nodejs-less',
    ]:
    ensure  => latest,
    require => [ Yumrepo['EPEL'] ]
  }

  package {
    'elasticsearch':
      ensure  => latest,
      require => [ Yumrepo['elasticsearch'], Package['java-1.7.0-openjdk'] ]
  }

  package {
    'supervisor':
      ensure  => latest,
      require => [ Yumrepo['supervisor'] ]
  }

  file {
    '/etc/socorro':
      ensure => directory;

    'alembic.ini':
      path    => '/etc/socorro/alembic.ini',
      content => template('/var/cache/puppet/templates/alembic.ini.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'collector.ini':
      path    => '/etc/socorro/collector.ini',
      content => template('/var/cache/puppet/templates/collector.ini.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'middleware.ini':
      path    => '/etc/socorro/middleware.ini',
      content => template('/var/cache/puppet/templates/middleware.ini.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'processor.ini':
      path    => '/etc/socorro/processor.ini',
      content => template('/var/cache/puppet/templates/processor.ini.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'crontabber.ini':
      path    => '/etc/socorro/crontabber.ini',
      content => template('/var/cache/puppet/templates/crontabber.ini.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'socorro_nginx.conf':
      path    => '/etc/nginx/conf.d/socorro_nginx.conf',
      source  => '/var/cache/puppet/files/etc_nginx_conf.d/socorro_nginx.conf',
      owner   => 'nginx',
      ensure  => file,
      require => Package['nginx'],
      notify  => Service['nginx'];

    'socorro_crontab':
      path   => '/etc/cron.d/socorro',
      source => '/var/cache/puppet/files/etc_cron.d/socorro',
      owner  => 'root',
      ensure => file;

    'local.py':
      path    => '/etc/socorro/local.py',
      content => template('/var/cache/puppet/templates/local.py.erb'),
      require => File['/etc/socorro'],
      ensure  => file;

    'supervisord.conf':
      path    => '/etc/supervisord.conf',
      source  => '/var/cache/puppet/files/etc/supervisord.conf',
      owner   => 'root',
      ensure  => file;
  }

}
