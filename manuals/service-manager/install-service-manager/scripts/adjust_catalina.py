"""

Script to create a new catalania.sh script with JAVA_OPT added in.

"""

import sys

catalina_in = sys.argv[1]
catalina_out = sys.argv[2]
java_opts = sys.argv[3]

out = open(catalina_out,'w', 0755)

for line in open(catalina_in):
    if line.startswith('# OS specific support.  $var _must_ be set to either true or false.'):
        out.write("\nJAVA_OPTS=\"%s\"\n\n" % open(java_opts).read().strip())
    out.write(line)
