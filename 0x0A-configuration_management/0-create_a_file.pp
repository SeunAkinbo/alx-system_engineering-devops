# This file uses puppet to create a file in /tmp

file { 'resource title':
  path       => /tmp/school
  permission => 0744
  owner      => www-data
  group      => www-data
  content    => I love Puppet
}
