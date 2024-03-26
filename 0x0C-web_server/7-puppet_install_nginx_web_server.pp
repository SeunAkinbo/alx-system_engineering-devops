# Puppet script to configure Nginx server

include stdlib

package { 'nginx':
  ensure  => installed,
}

# Set file paths
$FILE_PATH = '/var/www/html/index.html'
$NGINX_CONF = '/etc/nginx/sites-available/default'

# Installing nginx
exec { 'install nginx':
  command  => 'sudo apt -y update && sudo apt -y install nginx',
  provider => shell,
}

file { "$NGINX_CONF":
  content => "server {
		listen 80 default_server;
		server_name _;
		root /var/www/html;
		location / {
		index index.html;
          	}
		rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
	}",
  require => Exec['install nginx'],
}

file { "$FILE_PATH":
  ensure  =>  'file',
  content =>  'Hello World!',
  require =>  Exec['install nginx'],
}

exec { 'run':
  command  => 'sudo service nginx restart',
  provider => shell,
}
