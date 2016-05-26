"""

Copy a tomcat users configuration file to a new configuration file but add a tomcat user
that can act as the Tomcat manager. 

   $ python adjust_tomcat_users1.py XML_IN XML_OUT USER PASSWD

This adds the user and gives it the manager-gui role.

"""

import sys

tomcat_users_org = sys.argv[1]
tomcat_users = sys.argv[2]
user = sys.argv[3]
passwd = sys.argv[4]

out = open(tomcat_users, 'w')

for line in open(tomcat_users_org):
    if line.startswith('</tomcat-users>'):
        out.write('  <user username="' + user + '" password="' + passwd + 
                  '" roles="manager-gui"/>' + "\n")
    out.write(line)
