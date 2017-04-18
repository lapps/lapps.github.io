#!/bin/csh -f

# Script to install Active BPEL. Assumes that there is a working Service Manager
# installation. This is the first part of the installation process. Make sure that tomcat
# is not running before executing this script.
#
# Usage:
#
#   ./install-activebpel.sh SOURCES TOMCAT_DIRECTORY
#
#   SOURCES          - directory with tomcat, langrid and bpel sources
#   TOMCAT_DIRECTORY - directory where Tomcat will be installed, 
#                      for example: /Users/marc/Sites/tomcat-bpel


# source directory and tomcat installation directory
set sources = $1
set tomcat_dir = $2

# sources needed, these should be the only lines that may need to be edited
set tomcat_source = $sources/tomcat/apache-tomcat-6.0.35
#set lgrid_source = $sources/langrid/langrid-corenode-p2p-2.0.0-20120525
set lgrid_source = $sources/langrid/langrid-corenode-p2p-2.0.0-20120718
set bpel_source = $sources/active-bpel/activebpel-5.0.2

# file with user settings, edit this file if needed
set settings_file = settings-active-bpel.txt

# adding to tomcat
set lgrid_pre = $lgrid_source/tomcat-ae/pre
set lgrid_post = $lgrid_source/tomcat-ae/post


echo
echo INSTALLING ACTIVE BPEL, PART 1
echo

if ($#argv != 2) then 
    echo Wrong number of arguments -- usage: install-active-bpel-c.sh SOURCES TOMCAT_DIR
    echo
    exit
endif

# First clean out old stuff
echo % rm -rf $tomcat_dir
rm -rf $tomcat_dir

# Copy tomcat
echo % cp -R $tomcat_source $tomcat_dir 
cp -R $tomcat_source $tomcat_dir

# Additions to tomcat, part 1
echo % "cp -R $lgrid_pre/* $tomcat_dir"
cp -R $lgrid_pre/* $tomcat_dir

# runnng the bpel install script
echo % setenv CATALINA_HOME $tomcat_dir
setenv CATALINA_HOME $tomcat_dir
echo % cd $bpel_source
cd $bpel_source
echo % chmod 755 install.sh 
chmod 755 install.sh 
echo % ./install.sh 
./install.sh 

# starting the server
echo % cd ../../..
cd ../../..
echo % $tomcat_dir/bin/startup.sh
$tomcat_dir/bin/startup.sh

echo
echo DONE
echo
