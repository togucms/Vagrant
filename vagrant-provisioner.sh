#! /bin/bash

# NodeJS
curl -sL https://deb.nodesource.com/setup | sudo bash -

# Install needed packages
DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs unzip default-jre mysql-server-5.6 mysql-client-5.6 git vim libmcrypt-dev apache2 php5 php5-mcrypt php5-cli php5-gd php5-mysql

# Compass

if [ ! -f /usr/local/rvm/gems/ruby-2.0.0-p481/bin/compass ]
then
    curl -L get.rvm.io | bash -s stable --auto

    source /etc/profile.d/rvm.sh

    rvm install 2.0.0

    rvm use 2.0.0

    gem update --system

   gem install compass
fi

# Sencha CMD

if [ ! -e SenchaCmd-4.0.4.84-linux-x64.run ]
then
    echo -n "Downloading Sencha Cmd... "
    wget -qc http://cdn.sencha.com/cmd/4.0.4.84/SenchaCmd-4.0.4.84-linux-x64.run.zip
    echo "done"

    echo -n "Unpacking Sencha Cmd... "
    unzip -q SenchaCmd-4.0.4.84-linux-x64.run.zip
    echo "done"

    chmod +x SenchaCmd-4.0.4.84-linux-x64.run

    printf "\n\n\n\n\n\ny\n/home/vagrant\ny\n" | ./SenchaCmd-4.0.4.84-linux-x64.run

    source /root/.profile

    echo 'export PATH=/home/vagrant/Sencha/Cmd/4.0.4.84:$PATH' >> /home/vagrant/.profile
    echo 'export SENCHA_CMD_3_0_0="/home/vagrant/Sencha/Cmd/4.0.4.84"' >> /home/vagrant/.profile

    sencha repo add togu http://packages.togu.io
fi

# Composer
if [ ! -e /usr/local/bin/composer ]
then
    curl -sS https://getcomposer.org/installer | php

    mv composer.phar /usr/local/bin/composer
fi

# Composer create-project 
if [ ! -e /vagrant/web ]
then
    composer create-project togu/cms /vagrant/web dev-master
fi

# Install ExtJS if needed
if [ ! -e /vagrant/web/admin/ext ]
then
    echo -n "Installing ExtJS..."

    wget -qc http://cdn.sencha.com/ext/gpl/ext-4.2.1-gpl.zip

    rm -rf ext-4.2.1.883

    unzip -q ext-4.2.1-gpl.zip

    sencha generate workspace /vagrant/web/admin

    sencha -sdk /home/vagrant/ext-4.2.1.883 generate app test /vagrant/web/admin/test

    rm -rf /vagrant/web/admin/test

    echo "done"
fi

# Setup the vhost
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /vagrant/web/web

        <Directory "/vagrant/web/web" >
                Options +FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load 

/etc/init.d/apache2 restart

# Grunt & Bower
cd /vagrant/web

npm install -g bower grunt-cli

sudo npm install # Forces npm to run as root

bower install --allow-root

grunt build

# Setup the db

app/console doctrine:database:drop --force

app/console doctrine:database:create

app/console doctrine:schema:create

app/console doctrine:phpcr:repository:init

app/console doctrine:phpcr:fixtures:load -n

app/console fos:user:create test test@test.com test --super-admin

chmod -R a+w app/cache app/logs web/uploads frontend/compiled
