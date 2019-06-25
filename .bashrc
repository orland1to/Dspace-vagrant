#setup commands to work with Dspace
alias dspace-remove-installer='sudo rm -R /home/vagrant/DSpace/dspace/target/dspace-installer/*'
alias dspace-compile='cd /home/vagrant/DSpace && mvn package -o && cd /home/vagrant/DSpace/dspace/target/dspace-installer && ant update &&  sudo /etc/init.d/tomcat7 stop && sudo /etc/init.d/tomcat7 start'
alias tomcat-restart='sudo /etc/init.d/tomcat7 stop && sudo /etc/init.d/tomcat7 start'
alias tomcat-stop='/etc/init.d/tomcat7 stop'
alias tomcat-start=' sudo /etc/init.d/tomcat7 start'
