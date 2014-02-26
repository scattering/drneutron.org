#!/usr/bin/env python
"""
Start the drneutron server.

Starts the server in debug mode. Set "DJANGO_PRODUCTION=1" in os.environ to
start in production mode.  This is done automatically in apps/wsgi.py.

Use ./resetdb.sh to clear the debug database (resetdb.bat on windows).
"""
import sys, os

from django.core.management import execute_from_command_line

# put the current directory on the path
path=os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0, path)
print "\n".join(sys.path)

# Make sure UB matrix calculator is compiled and on the path
sys.dont_write_bytecode = True


# Run django
if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "website.settings")
    execute_from_command_line(sys.argv)
