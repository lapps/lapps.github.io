"""

Takes the command line argument to the function and prints it to the standard
output with a question mark added to the end.

"""

import sys

from marks import question_mark

print sys.argv[1] + question_mark

