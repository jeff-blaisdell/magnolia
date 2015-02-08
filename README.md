Magnolia CMS
==========
A demo integration o Grails with the Magnolia CMS.

### Technologies
The following are the primary technologies found in this project.
* Magnolia CMS (http://www.magnolia-cms.com/)
* Grails (https://grails.org/)
* Vagrant (https://www.vagrantup.com/)
* Chef (https://www.getchef.com/chef/)

### Getting Started
##### Prerequisites
* Vagrant - _https://www.vagrantup.com/downloads.html_ (Built against 1.7.2)
* Chef DK - _https://downloads.chef.io/chef-dk/_ (Built against 0.3.6)
* Grails - _https://grails.org/_ (Built against 2.4.4)
* Java - _http://www.oracle.com/technetwork/java/index.html_ (Built against JDK 1.7)
* Vagrant Berkshelf Plugin - _https://github.com/berkshelf/vagrant-berkshelf_
* Vagrant Omnibus Plugin - _https://github.com/chef/vagrant-omnibus_

##### Running Application
###### Provision a server running MySQL / Magnolia CMS.
1. ```cd ${project_root}/provision/chef/cookbooks/magnolia```
2. ```vagrant up```

###### Start Grails Web Application
1. ```cd ${project_root}/magnolia-app```
2. ```./grailsw run-app```

#### Integrate w/ IntelliJ
1. From Intellij main menu - Import Project
2. Select ```${project_root}```
3. Select to import project from existing sources.
4. Add JDK 1.7 / Grails 2.4.4 as SDK / Framework
