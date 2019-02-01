#!/usr/bin/env bash

update() {
  echo "Updating box software"
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y tree
}

# Language configuration
lang_conf(){
  if [[ -z "${LC_ALL}" ]]; then
    sudo echo "LANG=en_US.UTF-8" >> /etc/environment
    sudo echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
    sudo echo "LC_ALL=en_US.UTF-8" >> /etc/environment
    sudo echo "LC_CTYPE=en_US.UTF-8" >> /etc/environment
  fi
}

# Postgres installation
apache() {

  echo "Installing apache 2"
  sudo apt-get -y install apache2
}

java() {
  echo "Installing java"
  
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get upgrade
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get -y  install openjdk-8-jre
    
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections 
    sudo apt-get -y  install openjdk-8-jdk
    sudo apt install oracle-java8-set-default
    sudo update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java 
    echo "JAVA_HOME"
    echo $JAVA_HOME 
    sudo chmod 777 -R /etc/profile
    
    echo "JAVA_HOME='/usr/lib/jvm/java-8-oracle'">/etc/profile   

    echo "PATH='$PATH':'$JAVA_HOME/bin'">/etc/profile 

    source /etc/profile 

    echo $JAVA_HOME 

    echo $PATH
  
}
maven() {
  echo "------------- install maven"
  
  sudo apt-get install -y maven
  mvn -version 
  
}
apache-ant() {
   
    echo "------------- intalling apache ant"

    sudo wget https://www-us.apache.org/dist//ant/binaries/apache-ant-1.10.5-bin.tar.gz
    sudo tar -xzvf apache-ant-1.10.5-bin.tar.gz
    sudo cp -r apache-ant-1.10.5/ /usr/local/ant
    sudo rm -rf apache-ant-1.10.5-bin.tar.gz
    ant -version
  
}

postgres() {
  
  
     echo "-------------- installing postgres 11 currently"
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
    sudo apt-get -y update && sudo apt-get -y upgrade
    sudo apt-get install -y postgresql postgresql-contrib libpq-dev pgadmin3
   
  
    sudo chmod 777 -R /etc/postgresql/11
    sudo echo "host     dspace     dspace     127.0.0.1     255.255.255.255     md5" >> /etc/postgresql/11/main/pg_hba.conf
    sudo echo "host     all     all     127.0.0.1/32     md5" >> /etc/postgresql/11/main/pg_hba.conf
    sudo echo "listen_addresses = 'localhost' ">> /etc/postgresql/11/main/postgresql.conf
    sudo service postgresql restart
    
  
}
tomcat() {
  
    echo "-------------- install tomcat"
    sudo apt-get -y install tomcat7
    sudo chmod -R 777 /etc/default/tomcat7
    echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre">>/etc/default/tomcat7
    
    sudo /etc/init.d/tomcat7 start
    


 }
 Dspace-clone(){
    cd 
    sudo chmor -R 777 .
    sudo apt-get -y install git
    echo "-------------- Clone DSpace"
    git clone https://github.com/RepositorioUTM/DSpace.git
    cd DSpace
    git checkout dspace-6_x
    git branch -a
    git branch -r
    cp /home/vagrant/DSpace/dspace/config/local.cfg.EXAMPLE /home/vagrant/DSpace/dspace/config/local.cfg
    sudo sed -i 's|dspace.dir=/dspace|dspace.dir=/home/vagrant/install|g' /home/vagrant/DSpace/dspace/config/local.cfg
    sudo sed -i 's|dspace.name = DSpace at My University|dspace.name = DSpace at UTM|g' /home/vagrant/DSpace/dspace/config/local.cfg
 }
 DB(){
    echo "------------- Configuración de la base de datos"
    sudo -u postgres bash -c "psql -c \"CREATE USER dspace WITH PASSWORD 'dspace';\""
    sudo -u postgres bash -c "psql -c \"CREATE DATABASE dspace;\""
    sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE dspace to dspace;\""
    sudo -u postgres bash -c "psql -d dspace -c \"CREATE EXTENSION IF NOT EXISTS pgcrypto;\""
    sudo -u postgres bash -c "psql -c \"ALTER DATABASE dspace owner to dspace;\""
    
    echo " Restarting Postgres server"
    sudo service postgresql restart
    # psql postgres
    # createuser --username=postgres --no-superuser --pwprompt dspace
    # createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
    # psql --username=postgres dspace -c "CREATE EXTENSION  pgcrypto;"
    # \q
    
    
    
}
configuraciones(){

  echo "------------- Crear directorio de instalación"
  cd 
  sudo mkdir  /home/vagrant/install
  sudo chmod -R 777 /home/vagrant/install
  sudo chown  -R tomcat7:tomcat7 /home/vagrant/install

  echo "-------------- Construir el paquete de instalación"
  cd /home/vagrant/DSpace
  mvn package
}
instalar(){
  echo "-------------- Instalar DSpace"
  sudo chmod 777 -R /home/vagrant/DSpace/dspace/target/dspace-installer
  cd /home/vagrant/DSpace/dspace/target/dspace-installer
  ant fresh_install
}
personalizar(){
  echo "--------------- crear cuenta del administrador"
  sudo chown -R tomcat7:tomcat7 /dspace
  sudo chmod 777 -R /home/vagrant/install
  #echo -e "orlandosalvadorcamarillomoreno@gmail.com\nOrlando\nCamarillo" | dspace
  #/dspace/bin/dspace  create-administrator 

<<<<<<< HEAD:setup/box_setup.sh
    echo "---------------apuntar tomcat a  los archivos de personalización de interfaz"
    sudo sed -i 's|appBase="webapps"|appBase="/home/vagrant/install/webapps"|g' /etc/tomcat7/server.xml
    echo "-----------------------------------/n-------------/n---------------------aumentando memoria "
    sudo sed -i 's|JAVA_OPTS="-Djava.awt.headless=true |#JAVA_OPTS="-Xmx1024m -Dfile.encoding=UTF-8"|g' /etc/default/tomcat7
    sudo echo "JAVA_OPTS=\"-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms512m -Xmx512m -XX:NewSize=512m -XX:MaxNewSize=512m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:+DisableExplicitGC\"">>/etc/default/tomcat7
=======
    echo "--------------- Copiar los archivos de personalización de interfaz"
    sudo sed -i 's|appBase="webapps"|appBase="/dspace/webapps"|g' /etc/tomcat7/server.xml
    echo "-----------------------------------/n-------------/n---------------------aumentando memoria "
    sudo sed -i 's|JAVA_OPTS="-Djava.awt.headless=true |#JAVA_OPTS="-Xmx1024m -Dfile.encoding=UTF-8"|g' /etc/default/tomcat7
    sudo echo "JAVA_OPTS=\"-Dfile.encoding=UTF-8 -server -Xms1536m -Xmx1536m -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:PermSize=512m -XX:MaxPermSize=1024m -XX:+DisableExplicitGC\"">>/etc/default/tomcat7
>>>>>>> 0f7c3d69ebd509c2c51c5f587fc3e17b5eac16ac:bin/box_setup.sh

  echo "--------------- Reiniciar tomcat"

 sudo /etc/init.d/tomcat7 stop

 sudo /etc/init.d/tomcat7 start
}
cleanup() {
  sudo apt-get -y autoremove && sudo apt-get autoclean
}

finalized(){
  echo "cd /vagrant/" >> ~/.bashrc
}

setup(){
  update
  lang_conf
  apache
  java
  maven
  apache-ant
  postgres
  tomcat
  Dspace-clone
  DB
  configuraciones
  instalar
  personalizar
  finalized
  cleanup
}

setup "$@"
