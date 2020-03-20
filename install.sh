#sudo apt -y update

echo 'Inicio Aprovisionamiento' > /home/vagrant/share/vm-provision.log
env >> /home/vagrant/share/vm-provision.log

#Generar certificado autofirmado
sudo curl -L "https://raw.githubusercontent.com/ConnorAtherton/shell-helpers/master/scripts/ssl_setup.sh" -o /usr/local/bin/ssl-auto-setup
chmod +x /usr/local/bin/ssl-auto-setup
cd /home/vagrant/share/server/certs
sed -i "s/domain.example/$VG_DOCKER_DOMAIN/g" csr.config
sudo /usr/local/bin/ssl-auto-setup --self myicr csr.config

#Instalar docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo docker-compose --version >> /home/vagrant/share/vm-provision.log

echo "127.0.0.1 $VG_DOCKER_DOMAIN" >> /etc/hosts

#Canonical Repo
#sudo apt-get update
#sudo apt -y --only-upgrade install docker.io
#sudo apt -y install docker.io
#/etc/init.d/docker start

#Docker CE Repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker

sudo docker --version >> /home/vagrant/share/vm-provision.log

#Generar el usuario y clave
sudo docker run --entrypoint htpasswd registry:2 -Bbn $VG_DOCKER_USER $VG_DOCKER_PSWD > /home/vagrant/share/server/auth/htpasswd

cd /home/vagrant/share/server
sudo /bin/bash -c "source /etc/profile.d/myvars.sh && docker-compose up -d"