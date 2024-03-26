# Puppet script to configure Nginx server

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Set file paths
$ERROR_404_FILE = '/var/www/html/page_404.html'
$NGINX_CONF = '/etc/nginx/sites-available/default'
$FILE_PATH = '/var/www/html/index.html'

# Create index file with 'Hello World!'
file { $FILE_PATH:
  ensure  => file,
  content => 'Hello World!',
}

# Start Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

# Allow Nginx through firewall
firewall { '100 Allow nginx access':
  port   => 80,
  proto  => 'tcp',
  action => 'accept',
}

# Set permissions for Nginx directories
file { '/var/www/html':
  ensure  => directory,
  recurse => true,
  owner   => $USER,
  group   => $USER,
  mode    => '755',
}

# Configure Nginx redirection and custom 404 page
file_line { 'nginx_redirection':
  path   => $NGINX_CONF,
  line   => "    rewrite /redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;",
  after  => "server_name _;",
  notify => Service['nginx'],
}

file_line { 'nginx_custom_404':
  path   => $NGINX_CONF,
  line   => "    error_page 404 /page_404.html;",
  after  => "server_name _;",
  notify => Service['nginx'],
}

file { $ERROR_404_FILE:
  ensure  => file,
  content => "Ceci n'est pas une page\n",
}

# Restart Nginx service after configuration changes
exec { 'nginx_restart':
  command     => 'service nginx restart',
  refreshonly => true,
}
