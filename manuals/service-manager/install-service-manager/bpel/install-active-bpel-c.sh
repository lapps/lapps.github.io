#!/bin/csh -f

# Script to install the Active BPEL. Assumes that there is a working Service Manager
# installation. This assume all prior steps in the installation have been performed:
#
# % ./install-active-bpel-a.sh sources ~/Documents/lapps/code/install-service-manager/tomcat-bpel
# % tomcat-bpel/bin/shutdown.sh
# % ./install-active-bpel-b.sh sources tomcat-bpel
# % tomcat-bpel/bin/shutdown.sh


# sources, settings and target directory
set tomcat_dir = $1
set settings_file = $2

# tomcat_users.xml
set tomcat_users = $tomcat_dir/conf/tomcat-users.xml
set tomcat_users_org = $tomcat_dir/conf/tomcat-users-org.xml

# active-bpel.xml
set active_bpel = $tomcat_dir/conf/Catalina/localhost/active-bpel.xml
set active_bpel_org = $tomcat_dir/conf/Catalina/localhost/active-bpel-org.xml

# bpr/langrid.ae.properties
set ae_properties = $tomcat_dir/bpr/langrid.ae.properties
set ae_properties_org = $tomcat_dir/bpr/langrid.ae.properties.org

# scripts to adjust tomcat_users.xml and active-bpel.xml
set adjust_tomcat_users_script = scripts/adjust_tomcat_users2.py
set adjust_bpel_script = scripts/adjust_active_bpel.py
set adjust_properties_script = scripts/adjust_properties.py


if ($#argv != 2) then 
    echo Wrong number of arguments -- usage: install-active-bpel-c.sh TOMCAT_DIR SETTINGS_FILE
    exit
endif

echo
echo INSTALLING ACTIVE BPEL, PART 3
echo

# Modify conf/tomcat-users.xml to enable access for active-bpel
if (! -e $tomcat_users_org) then
    echo % mv $tomcat_users $tomcat_users_org
    mv $tomcat_users $tomcat_users_org
endif
echo % python $adjust_tomcat_users_script $tomcat_users_org $tomcat_users 
python $adjust_tomcat_users_script $tomcat_users_org $tomcat_users 

# Modifiy conf/Catalina/localhost/active-bpel.xml
if (! -e $active_bpel_org) then
    echo % mv $active_bpel $active_bpel_org
    mv $active_bpel $active_bpel_org
endif
echo % python $adjust_bpel_script $settings_file $active_bpel_org $active_bpel
python $adjust_bpel_script $settings_file $active_bpel_org $active_bpel

# Modify bpr/langrid.ae.properties
if (! -e $ae_properties_org) then
    echo % mv $ae_properties $ae_properties_org
    mv $ae_properties $ae_properties_org
endif
echo % python $adjust_properties_script $settings_file $ae_properties_org $ae_properties
python $adjust_properties_script $settings_file $ae_properties_org $ae_properties

# starting the server
echo % $tomcat_dir/bin/startup.sh
$tomcat_dir/bin/startup.sh

echo
echo DONE
echo

