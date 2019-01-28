cd /home/dspace/dspace-install
ant update
ant build_wars 
cp -r /home/dspace/dspace-install/webapps/* /var/lib/tomcat7/webapps