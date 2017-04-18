#!/bin/csh -f

# Script to install the Active BPEL. Assumes that there is a working Service Manager
# installation. This is the second part of the installation. Before running this, you
# should run install-active-bpel-a.sh and then start and stop the tomcat server.
#
# Usage:
#
#   ./install-activebpel.sh SOURCES_DIRECTORY TOMCAT_DIRECTORY
#
#   SOURCES_DIRECTORY - directory with langrid sources
#   TOMCAT_DIRECTORY  - directory where Tomcat will be installed, 
#                       should be the same name as used in active-bpel-a.sh


# sources needed, these should be the only lines that may need to be edited
#set sources = /Users/marc/Documents/LAPPS/service_grid/sources
#set lgrid_source = $sources/langrid-corenode-p2p-2.0.0-20120525
set sources = $1
set lgrid_source = $sources/langrid/langrid-corenode-p2p-2.0.0-20120718

# tomcat directory
set tomcat_dir = $2

# adjusting catalina
set adjust_catalina_script = scripts/adjust_catalina.py
set catalina_org = $tomcat_dir/bin/catalina.sh.org
set catalina = $tomcat_dir/bin/catalina.sh
set java_opts = $lgrid_source/tomcat-ae/javaopts.txt

# adding to tomcat
set lgrid_post = $lgrid_source/tomcat-ae/post


echo
echo INSTALLING ACTIVE BPEL, PART 2
echo

if ($#argv != 2) then 
    echo Wrong number of arguments -- usage: install-active-bpel-c.sh SOURCES TOMCAT_DIR 
    exit
endif

# Additions to tomcat, part 2
echo % "cp -R $lgrid_post/* $tomcat_dir"
cp -R $lgrid_post/* $tomcat_dir

# fixing catalina script
echo % mv $catalina $catalina_org
mv $catalina $catalina_org
echo % python $adjust_catalina_script $catalina_org $catalina $java_opts
python $adjust_catalina_script $catalina_org $catalina $java_opts
echo % chmod 755 $catalina
chmod 755 $catalina

# starting the server
echo % $tomcat_dir/bin/startup.sh
$tomcat_dir/bin/startup.sh

echo
echo DONE
echo
