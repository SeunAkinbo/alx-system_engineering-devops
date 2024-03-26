# Puppet script to configure Nginx server

include ::stdlib

# Install nginx package
package { 'nginx':
  ensure  => installed
}

# Installing nginx package
#exec { 'install nginx':
#  command  => 'sudo apt -y update && sudo apt -y install nginx',
#  provider => shell,
#}

#Define a custom site configuration for nginx
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => "server {
		listen 80 default_server;
		server_name _;
		root /var/www/html;
		location / {
		index index.html;
          	}
		rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
	}",
  notify  => Service['nginx'],
  require => Package['nginx']
}

#Define the index.html file content
file { '/var/www/html/index.html':
  ensure  =>  'file',
  content =>  'Hello World!',
  require =>  Package['nginx']
}

# Ensure nginx is running and restart if necessary
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx']
}

# Notify nginx service restart when the configuration changes
File['/etc/nginx/sites-available/default'] -> Service['nginx']
