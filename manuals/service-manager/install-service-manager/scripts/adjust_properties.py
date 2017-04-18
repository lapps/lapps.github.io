"""

Add parameters for connection to Service Manager to active-bpel.xml.

Uses parameter settings from settings-active-bpel.txt.

"""

import sys

from utils import create_mappings, print_mappings, replace_vars


(settings_file, infile, outfile) = sys.argv[1:4]

mappings = create_mappings(settings_file)

lines = open(infile).readlines()
lines = replace_vars(lines, mappings)

out = open(outfile, 'w')
out.write("".join(lines))

    

