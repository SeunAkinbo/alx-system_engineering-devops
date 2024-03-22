# Killing a system process 'killmenow' using pkill and puppet resource exec

exec { 'kill_process':
  command  => '/usr/bin/pkill killmenow',
  provider => shell,
  onlyif   => '/usr/bin/pgrep killmenow'
}
