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
      baseurl  =>
        'http://repos.fedorapeople.org/repos/rmarko/supervisor/epel-6/noarch/',
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
      ensure  => file,
      path    => '/etc/socorro/alembic.ini',
      content => template('/var/cache/puppet/templates/alembic.ini.erb'),
      require => File['/etc/socorro'];

    'collector.ini':
      ensure  => file,
      path    => '/etc/socorro/collector.ini',
      content => template('/var/cache/puppet/templates/collector.ini.erb'),
      require => File['/etc/socorro'];

    'middleware.ini':
      ensure  => file,
      path    => '/etc/socorro/middleware.ini',
      content => template('/var/cache/puppet/templates/middleware.ini.erb'),
      require => File['/etc/socorro'];

    'processor.ini':
      ensure  => file,
      path    => '/etc/socorro/processor.ini',
      content => template('/var/cache/puppet/templates/processor.ini.erb'),
      require => File['/etc/socorro'];

    'crontabber.ini':
      ensure  => file,
      path    => '/etc/socorro/crontabber.ini',
      content => template('/var/cache/puppet/templates/crontabber.ini.erb'),
      require => File['/etc/socorro'];

    'common_elasticsearch.ini':
      ensure  => file,
      path    => '/etc/socorro/common_elasticsearch.ini',
      content => template(
        '/var/cache/puppet/templates/common_elasticsearch.ini.erb'),
      require => File['/etc/socorro'];

    'common_fs.ini':
      ensure  => file,
      path    => '/etc/socorro/common_fs.ini',
      content => template('/var/cache/puppet/templates/common_fs.ini.erb'),
      require => File['/etc/socorro'];

    'common_logging.ini':
      ensure  => file,
      path    => '/etc/socorro/common_logging.ini',
      content =>
        template('/var/cache/puppet/templates/common_logging.ini.erb'),
      require => File['/etc/socorro'];

    'common_postgresql.ini':
      ensure  => file,
      path    => '/etc/socorro/common_postgresql.ini',
      content =>
        template('/var/cache/puppet/templates/common_postgresql.ini.erb'),
      require => File['/etc/socorro'];

    'common_rabbitmq.ini':
      ensure  => file,
      path    => '/etc/socorro/common_rabbitmq.ini',
      content =>
        template('/var/cache/puppet/templates/common_rabbitmq.ini.erb'),
      require => File['/etc/socorro'];

    'common_redactor.ini':
      ensure  => file,
      path    => '/etc/socorro/common_redactor.ini',
      content =>
        template('/var/cache/puppet/templates/common_redactor.ini.erb'),
      require => File['/etc/socorro'];

    'crashmover_secrets.ini':
      ensure  => file,
      path    => '/etc/socorro/common_secrets.ini',
      content =>
        template('/var/cache/puppet/templates/common_secrets.ini.erb'),
      require => File['/etc/socorro'];

    'cron_submitter_secrets.ini':
      ensure  => file,
      path    => '/etc/socorro/common_secrets.ini',
      content =>
        template('/var/cache/puppet/templates/common_secrets.ini.erb'),
      require => File['/etc/socorro'];

    'crontabber_secrets.ini':
      ensure  => file,
      path    => '/etc/socorro/crontabber_secrets.ini',
      content =>
        template('/var/cache/puppet/templates/crontabber_secrets.ini.erb'),
      require => File['/etc/socorro'];

    'middleware_secrets.ini':
      ensure  => file,
      path    => '/etc/socorro/middleware_secrets.ini',
      content =>
        template('/var/cache/puppet/templates/middleware_secrets.ini.erb'),
      require => File['/etc/socorro'];

    'processor_secrets.ini':
      ensure  => file,
      path    => '/etc/socorro/processor_secrets.ini',
      content =>
        template('/var/cache/puppet/templates/processor_secrets.ini.erb'),
      require => File['/etc/socorro'];

    'socorro_nginx.conf':
      ensure  => file,
      path    => '/etc/nginx/conf.d/socorro_nginx.conf',
      source  => '/var/cache/puppet/files/etc_nginx_conf.d/socorro_nginx.conf',
      owner   => 'nginx',
      require => Package['nginx'],
      notify  => Service['nginx'];

    'socorro_crontab':
      ensure => file,
      path   => '/etc/cron.d/socorro',
      source => '/var/cache/puppet/files/etc_cron.d/socorro',
      owner  => 'root';

    'local.py':
      ensure  => file,
      path    => '/etc/socorro/local.py',
      content => template('/var/cache/puppet/templates/local.py.erb'),
      require => File['/etc/socorro'];

    'supervisord.conf':
      ensure  => file,
      path    => '/etc/supervisord.conf',
      source  => '/var/cache/puppet/files/etc/supervisord.conf',
      owner   => 'root';
  }

}
