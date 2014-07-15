Exec {
  logoutput => 'on_failure'
}

import 'socorro'

$database_username  = hiera('database_username')
$database_password  = hiera('database_password')
$database_hostname  = hiera('database_hostname')
$middleware_url     = hiera('middleware_url')
$crash_stats_url    = hiera('crash_stats_url')
$crash_stats_host   = hiera('crash_stats_host')
$postgresql_url     = hiera('postgresql_url')
$default_product    = hiera('default_product')
$aws_access_key     = hiera('aws_access_key')
$aws_secret_key     = hiera('aws_secret_key')

node default {
  include webapp::socorro
}
