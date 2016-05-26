#!/bin/csh -f

# Script to install the Service Manager using a basic tomcat directory. An existing
# service manager will be removed (however, the underlying database is not deleted so you
# can run this for web code updates). The tomcat version should be service manager ready
# (see install-tomcat). After this, all you need to do is stop and restart tomcat.
#
# Usage:
#
#   ./install-manager.sh SETTINGS_FILE SOURCES TOMCAT_BASE TOMCAT_MANAGER 
#
#   SETTINGS_FILE  -  file with settings for the service_manager.xml config file
#   SOURCES        -  location of sources
#   TOMCAT_DIR     -  directory for the service manager tomcat instance 
#
# This script needs to be run from the directory it is in.
#
# NOTE: this script is now obsolete and its function is taken over by install.py.


if ($#argv != 3) then 
    echo Usage: install-manager.sh SETTINGS_FILE SOURCES TOMCAT_DIRECTORY
    exit
endif

# file with user settings and source and target directories
set settings_file = $1
set sources = $2
set tomcat_dir = $3

# this may need to be edited depending on how you set up the sources directory
#set tomcat_source = $sources/tomcat/apache-tomcat-6.0.35
set tomcat_source = $sources/tomcat/apache-tomcat-7.0.53
set commons_dbcp_1 = $sources/tomcat/commons-dbcp-1.4/commons-dbcp-1.4.jar
set commons_pool_1 = $sources/tomcat/commons-pool-1.6/commons-pool-1.6.jar
#set postgres_jdbc_1 = $sources/postgres/postgresql-9.1-902.jdbc4.jar
set postgres_jdbc_1 = $sources/postgres/postgresql-9.3-1101.jdbc4.jar
set lgrid_source = $sources/langrid/langrid-corenode-p2p-2.0.0-20120718/tomcat-langrid
# this is the best war file to use, do not use ${lgrid_source}/langrid-2.0.0.war
set service_manager_war = $sources/langrid/jp.go.nict.langrid.webapps.langrid-core-20130904.war
set service_manager_xml = ${lgrid_source}/conf/Catalina/localhost/langrid-2.0.xml

# no edits should be needed after this

# scripts
set insert_settings_script = scripts/create_service_manager_xml.py


if (-e $tomcat_dir) then
    echo "Directory $tomcat_dir already exists"
    exit
endif

echo
echo INSTALLING SERVICE MANAGER IN TOMCAT
echo

# Copy tomcat
echo % cp -R $tomcat_source $tomcat_dir 
cp -R $tomcat_source $tomcat_dir

# Copy libraries needed for tomcat
echo % cp $commons_dbcp_1 $tomcat_dir/lib
cp $commons_dbcp_1 $tomcat_dir/lib
echo % cp $commons_pool_1 $tomcat_dir/lib
cp $commons_pool_1 $tomcat_dir/lib
echo % cp $postgres_jdbc_1 $tomcat_dir/lib postgres_jdbc_2
cp $postgres_jdbc_1 $tomcat_dir/lib

# Add a tomcat user for the manager
set users_file = $tomcat_dir/conf/tomcat-users.xml
echo % cp $users_file $users_file.org
cp $users_file $users_file.org
echo % python scripts/adjust_tomcat_users1.py $users_file.org $users_file
python scripts/adjust_tomcat_users1.py $users_file.org $users_file

# Create server manager config file
echo % mkdir $tomcat_dir/conf/Catalina
echo % mkdir $tomcat_dir/conf/Catalina/localhost
mkdir $tomcat_dir/conf/Catalina
mkdir $tomcat_dir/conf/Catalina/localhost
echo % python $insert_settings_script 
echo '   ' $settings_file
echo '   ' $service_manager_xml 
echo '   ' $tomcat_dir/conf/Catalina/localhost/service_manager.xml
python $insert_settings_script $settings_file $service_manager_xml $tomcat_dir/conf/Catalina/localhost/service_manager.xml

# Copy server manager code
echo % cp $service_manager_war $tomcat_dir/webapps/service_manager.war
cp $service_manager_war $tomcat_dir/webapps/service_manager.war

echo
echo DONE
echo
echo "To start the server do"
echo
echo "   $ $tomcat_dir/bin/startup.sh"
echo

