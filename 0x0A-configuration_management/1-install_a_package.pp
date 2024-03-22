# Pip installing flask version 2.1.0
# and werkzeug version 2.1.1 using puppet

package {'flask':
  ensure   => '2.1.0',
  provider => 'pip3'
}

# Installs Werkzeug
package {'werkzeug':
  ensure   => '2.1.1',
  provider => 'pip3'
}

