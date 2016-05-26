
def create_mappings(filename):
    """Reads the settings file and creates a dictionary f variables and their values."""
    mappings = {}
    for line in open(filename):
        idx = line.find('#')
        if idx > -1:
            line = line[:idx]
        line = line.strip()
        if not line:
            continue
        result = line.split("\t",1)
        var = result[0].strip()
        if len(result) == 1:
            val = ''
        else:
            val = result[1].strip()
        mappings[var] = val
    return mappings

def print_mappings(mappings):
    for (var, val) in mappings.items():
        print "%s=%s" % (var, val)

def replace_vars(lines, mappings):
    """Replace variable names like ${NODE_URL} with the value."""
    new_lines = []
    for line in lines:
        for (var, val) in mappings.items():
            line = line.replace(var, val)
        new_lines.append(line)
    return new_lines
