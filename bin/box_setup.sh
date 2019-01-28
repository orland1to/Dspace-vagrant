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
  
    #sudo add-apt-repository -y ppa:webupd8team/java
   # sudo apt-get update
    sudo apt-get upgrade
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get -y  install openjdk-8-jre
    
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections 
    sudo apt-get -y  install openjdk-8-jdk

    update-alternatives --config java
    echo "JAVA_HOME"
    sudo chmod 777 -R /etc/profile
    echo"JAVA_HOME='/usr/lib/jvm/java-7-openjdk-amd64/jre'">/etc/profile   

    echo"PATH='$PATH':'$JAVA_HOME/bin'">/etc/profile 

    export  JAVA_HOME 

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
  
  
     echo "-------------- installing postgres"

    sudo apt-get install -y postgresql
  
    sudo chmod 777 -R /etc/postgresql/9.3
    sudo echo "host     dspace     dspace     127.0.0.1     255.255.255.255     md5" > /etc/postgresql/9.3/main/pg_hba.conf
    sudo echo "host     all     all     127.0.0.1/32     md5" > /etc/postgresql/9.3/main/pg_hba.conf

    sudo /etc/init.d/tomcat7 start
  
}
tomcat() {
  
    echo "-------------- install tomcat"
    sudo apt-get -y install tomcat7
  
 }
 Dspace-clone(){
    sudo apt-get -y install git
    echo "-------------- Clone DSpace"
    git clone https://github.com/RepositorioUTM/DSpace.git
    cd DSpace
    git checkout dspace-6_x
    git branch -a
    git branch -r
 }
 DB(){
    echo "------------- Configuración de la base de datos"
    psql postgres
    createuser --username=postgres --no-superuser --pwprompt dspace
    createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
    psql --username=postgres dspace -c "CREATE EXTENSION  pgcrypto;"
    \q
    cd dspace/config/
    cp local.cfg.EXAMPLE local.cfg
}
configuraciones(){

  echo "------------- Crear directorio de instalación"
  mkdir dspace -install
  sudo chown  - R tomcat7:tomcat7 /home/dspace/dspace-install/


  echo "-------------- Construir el paquete de instalación"
  cd dspace
  mvn package

  echo "-------------- Instalar DSpace"
  cd /dspace/target/dspace-installer
  ant -y fresh_install

  echo "-------------- desplegar las aplicaciones web"
  cp -r /home/dspace/dspace-install/webapps/* /var/lib/tomcat7/webapps/

  sudo chown -R tomcat8:tomcat8 /home/dspace/dspace-install/

  echo "--------------- crear cuenta del administrador"
  /home/dspace/dspace-install/bin/dspace create-administrator

    echo "--------------- Copiar los archivos de personalización de interfaz"


  echo "--------------- Reiniciar tomcat"

  /etc/init.d/tomcat7 stop

  /etc/init.d/tomcat7 start
}
cleanup() {
  sudo apt-get -y autoremove && sudo apt-get autoclean
}

finalized(){
  echo "cd /home/dspace/" >> ~/.bashrc
}

setup(){
  #update
  #lang_conf
  #apache
  #java
  #maven
  #apache-ant
  #postgres
  #tomcat
  #Dspace-clone
  DB
  #configuraciones
  #finalized
  cleanup
}

setup "$@"
