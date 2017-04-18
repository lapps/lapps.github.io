"""install.py

Script to install and start a Tomcat instance with the Service Manager. This was
tested on Mac OSX, but not yet on linux.

Assumptions:
- No Tomcat instance is currently running.
- There is a PostgreSQL database avaliable.
- A settings file is handed in with the appropriate values.
- All the needed sources are available in the sources directory.

Usage:

   ./install-manager.sh SETTINGS TARGET_DIR USER? PASSWORD?

   SETTINGS    -  file with service manager configuration settings
   TARGET_DIR  -  directory for the service manager tomcat instance
   USER        -  optional username for the tomcat manager, default is 'tomcat'
   PASSWORD    -  optional password for the tomcat manager, default is 'tomcatpw'
                  a password is required if a username is given (and vice versa)

This script needs to be run from the directory it is in.

See 00-readme.osx.html for more details.

"""

import os, sys


# ------------------------------------------------------------------------------

# BEGIN USER SETTINGS

# These may need to be edited if you chose to set up the sources directory
# differently than suggested or if you have different version of Tomcat, the
# Tomcat libraries or the Language Grid code.

SOURCES = 'sources'
TOMCAT = os.path.join(SOURCES, 'tomcat')
POSTGRES = os.path.join(SOURCES, 'postgres')
LGRID = os.path.join(SOURCES, 'langrid')

TOMCAT_SOURCE = os.path.join(TOMCAT, 'apache-tomcat-6.0.35')
TOMCAT_SOURCE = os.path.join(TOMCAT, 'apache-tomcat-7.0.53')
COMMONS_DBCP = os.path.join(TOMCAT, 'commons-dbcp-1.4', 'commons-dbcp-1.4.jar')
COMMONS_POOL = os.path.join(TOMCAT, 'commons-pool-1.6', 'commons-pool-1.6.jar')
POSTGRES_JDBC = os.path.join(POSTGRES, 'postgresql-9.1-902.jdbc4.jar')
POSTGRES_JDBC = os.path.join(POSTGRES, 'postgresql-9.3-1101.jdbc4.jar')

LGRID_SOURCE = os.path.join(LGRID, 'langrid-corenode-p2p-2.0.0-20120718', 'tomcat-langrid')
SERVICE_MANAGER_WAR = os.path.join(LGRID, 'jp.go.nict.langrid.webapps.langrid-core-20130904.war')
SERVICE_MANAGER_XML = os.path.join(LGRID_SOURCE, 'conf', 'Catalina', 'localhost', 'langrid-2.0.xml')

# END USER SETTINGS

# ------------------------------------------------------------------------------


INSERT_SETTINGS_SCRIPT = 'scripts/create_service_manager_xml.py'
ADD_TOMCAT_USER_SCRIPT = 'scripts/adjust_tomcat_users1.py'

def run_command(comment, *commands):
    print "\n", comment
    for command in commands:
        print '$', command
        os.system(command)


if __name__ == '__main__':
    
    settings = sys.argv[1]
    target_dir = sys.argv[2]

    tomcat_user = 'tomcat'
    tomcat_password = 'tomcatpw'
    print len(sys.argv)
    if len(sys.argv) > 4:
        tomcat_user = sys.argv[3]
        tomcat_password = sys.argv[4]
    
    if os.path.exists(target_dir):
        exit("Directory '%s' already exists" % target_dir)

    print "\nINSTALLING TOMCAT SERVICE MANAGER..."

    run_command('Copying basic tomcat...',
                "cp -R %s %s" % (TOMCAT_SOURCE, target_dir))

    run_command('Copying libraries needed for tomcat...',
                "cp %s %s/lib" % (COMMONS_DBCP, target_dir),
                "cp %s %s/lib" % (COMMONS_POOL, target_dir),
                "cp %s %s/lib" % (POSTGRES_JDBC, target_dir))

    tomcat_users_file = os.path.join(target_dir, 'conf', 'tomcat-users.xml')
    tomcat_users_file_org = os.path.join(target_dir, 'conf', 'tomcat-users.xml.org')
    run_command('Adding a tomcat user for the applications manager...',
                "cp %s %s" % (tomcat_users_file, tomcat_users_file_org),
                "python %s %s %s %s %s" % (ADD_TOMCAT_USER_SCRIPT,
                                           tomcat_users_file_org, tomcat_users_file, 
                                           tomcat_user, tomcat_password))

    run_command('Creating server manager config file...',
                "mkdir %s/conf/Catalina" % target_dir,
                "mkdir %s/conf/Catalina/localhost" % target_dir,
                "python %s %s %s %s/conf/Catalina/localhost/service_manager.xml" % \
                (INSERT_SETTINGS_SCRIPT, settings, SERVICE_MANAGER_XML, target_dir))

    run_command('Copying server manager code...',
                "cp %s %s/webapps/service_manager.war" % (SERVICE_MANAGER_WAR, target_dir))

    run_command('Starting Tomcat server...',
                "%s/bin/startup.sh" % target_dir)

    print "\nDONE\n"
    print "To shutdown and start the server do\n"
    print "   $ %s/bin/shutdown.sh" % target_dir
    print "   $ %s/bin/startup.sh\n" % target_dir
