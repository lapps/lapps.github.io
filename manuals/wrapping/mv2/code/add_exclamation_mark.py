"""

Takes the command line argument to the function and prints it to the standard
output with an exclamation mark added to the end.

"""

import sys

from marks import exclamation_mark

print sys.argv[1] + exclamation_mark

