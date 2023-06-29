from ubuntu:16.04

run apt-get update -y
run apt-get install -y nano vim git php python3 curl wget strace diffstat pkg-config build-essential tcpdump screen

run curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
run HASH=`curl -sS https://composer.github.io/installer.sig`
run php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
run php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Setup home environment
run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
env PATH /home/dev/bin:$PATH

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
run mkdir /var/shared/
run touch /var/shared/placeholder
run chown -R dev:dev /var/shared
volume /var/shared

workdir /home/dev
env HOME /home/dev
add vimrc /home/dev/.vimrc
add vim /home/dev/.vim
#add bash_profile /home/dev/.bash_profile
add gitconfig /home/dev/.gitconfig

# Link in shared parts of the home directory
run ln -s /var/shared/.ssh
run ln -s /var/shared/.bash_history
run ln -s /var/shared/.maintainercfg

run chown -R dev: /home/dev
user dev
