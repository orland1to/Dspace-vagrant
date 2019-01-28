# Recompilación   completa :(recompilación   completa   de   todo  Dspace) 
cd /home/dspace/dspace-install
ant clean
ant update
[Tomcat] /bin/shutdown.sh
cp build/*.war   /var/lib/tomcat7/webapps/  
sh /var/lib/tomcat7/bin/startup.sh

 