name             'magnolia'
maintainer       'Jeff Blaisdell'
maintainer_email ''
license          'All rights reserved'
description      'Installs/Configures magnolia'
long_description 'Installs/Configures magnolia'
version          '0.1.0'

recipe "magnolia::mysql", "Installs MySql."
recipe "magnolia::java", "Installs Java."

depends "java", "~> 1.29.0"
depends "mysql", "~> 6.0.2"
depends "database", "~> 3.0.0"
depends 'ark', '~> 0.9.0'
depends 'maven', '~> 1.2.0'
