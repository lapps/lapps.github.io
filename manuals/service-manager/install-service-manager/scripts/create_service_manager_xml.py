"""

Script to take the original grid settings in langrid-2.0.xml in the language grid
distribution and (i) remove unwanted lines and (ii) replace variable names with values
using settings.txt/

"""

import sys

from utils import create_mappings, print_mappings, replace_vars


def contains(line, string):
    return True if line.find(string) > -1 else False

def normalize_space(filename):
    """Takes all lines in filename and strips the ending newline character unless it is an
    empty line or the line ends with a >. """
    lines = []
    for line in open(filename):
        new_line = ''
        line = line.strip()
        if not line:
            lines.append("\n")
            continue
        if line.startswith('<Resource'): new_line += '   '
        if line.startswith('<Parameter'): new_line += '   '
        new_line += line + ' '
        if line[-1] == '>':
            new_line += "\n"
        lines.append(new_line)
    return lines


def delete_lines1(lines):
    """Removes lines that match one of the phrases defined in the phrases variable. """

    phrases = ['docBase', 
               '<Parameter name="appAuth.richApp.authIps"',
               'value="130.54.21.141, 133.243.3.19, 133.243.3.17, 220.157.233.123" />',
               '<Parameter name="appAuth.richApp.authKey" value="playgroundPass" />']

    def contains_phrase(line):
        for phrase in phrases:
            if contains(line, phrase): return True
        return False

    return [l for l in lines if not contains_phrase(l)]


def delete_lines2(lines):
    phrase = '${AE_TOMCAT_ADDRESS}'
    return [line for line in lines if not contains(line, phrase)]


if __name__ == '__main__':

    (settings_file, xml_file1, xml_file2) = sys.argv[1:4]

    mappings = create_mappings(settings_file)

    lines = normalize_space(xml_file1)
    lines = delete_lines1(lines)
    lines = [l + "\n" for l in ''.join(lines).split("\n")]
    lines = delete_lines2(lines)
    lines = replace_vars(lines, mappings)

    fh = open(xml_file2,'w')
    for line in lines:
        fh.write(line)
        
