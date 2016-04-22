name             'wsi_tomcat'
maintainer       'Ivan Suftin'
maintainer_email 'isuftin@usgs.gov'
license          'Public Domain'
description      'Installs and configures the Apache Tomcat servlet container '
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version          '0.1.9'
supports         'centos', '>= 6.5'

depends 'java', '>= 1.39.0'
