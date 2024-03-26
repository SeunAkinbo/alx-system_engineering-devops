# Install Nginx package
package { 'nginx':
  ensure => present,
}

# Ensure directories exist
file { [
  '/var/www/html',
  '/etc/nginx/sites-available',
]:
  ensure => directory,
}

# Create index.html with "Hello World!" content
file { '/var/www/html/index.html':
  ensure  => present,
  content => "Hello World!",
  owner   => root,
  group   => root,
  mode    => '0644',
}

# Create custom 404 page with content
file { '/var/www/html/page_404.html':
  ensure  => present,
  content => "Ceci n'est pas une page",
  owner   => root,
  group   => root,
  mode    => '0644',
}

# Open firewall port for Nginx (adjust service name if needed)
firewall {
  rule {
    name    => 'Open Nginx port',
    service => 'http',
    action  => accept,
  }
}

# Configure ownership and permissions for webroot
file { '/var/www/html':
  owner => '$::user',  # Use $::user for current user
  group => '$::user',  # Use $::user for current user
  mode  => '0755',
}

# Manage Nginx configuration using a template
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => template('nginx/default.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Define template content (nginx/default.erb)
template 'nginx/default.erb' {
  content <<EOF
server {
  listen 80;
  server_name _;

  # Serve static content from this directory
  root /var/www/html;

  # Include custom 404 page
  error_page 404 /page_404.html;

  # Redirect for /redirect_me to YouTube video
  rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;

  # Default location block
  location / {
    try_files $uri $uri/ /index.html;
  }

  # Access logging
  access_log /var/log/nginx/access.log;
}
EOF
}

# Restart Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => [
    Package['nginx'],
    File['/etc/nginx/sites-available/default'],
  ],
}

