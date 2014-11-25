Togu CMS Vagrantfile
=======

Run the following commands to install Togu in a Vagrant box

```
$ git clone https://github.com/togucms/Vagrant.git
$ cd Vagrant && vagrant up
```

You will be able to access togu at http://localhost:8080/ or http://192.168.33.10/

The admin interface is located at http://localhost:8080/admin or http://192.168.33.10/admin. The default user credentials are test / test

The source files will be installed into the `Vagrant/web` folder and can be easily accessed from the local machine. This folder is mounted by default with NFS for speed reasons and may require additional config. Read more at https://docs.vagrantup.com/v2/synced-folders/nfs.html. If you don't want to use NFS just comment out the following line https://github.com/togucms/Vagrant/blob/master/Vagrantfile#L10 from the Vagrantfile

## Developing

While developing you will need to run the following command:

```
$ vagrant ssh
$ cd /vagrant/web && grunt dev
```

This will watch for changes and automatically recompile the source files.

Enjoy!
