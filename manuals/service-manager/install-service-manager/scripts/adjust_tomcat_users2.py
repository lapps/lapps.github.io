"""

Add user and role to tomcat-users.xml. Role and user are hard-wired:

   user=admin 
   password=admin
   role=serviceGridAdmin

This is used when setting up BPEL.

"""

import sys

tomcat_users_1 = sys.argv[1]
tomcat_users_2 = sys.argv[2]

out = open(tomcat_users_2, 'w')

for line in open(tomcat_users_1):
    if line.startswith('</tomcat-users>'):
        out.write('  <role rolename="serviceGridAdmin" />' + "\n")
        out.write('  <user username="admin" password="admin" roles="serviceGridAdmin"/>' + "\n")
    out.write(line)
    
