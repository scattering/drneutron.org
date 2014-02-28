#!/usr/bin/env python
"""
Start the drneutron server.

Starts the server in debug mode. Set "DJANGO_PRODUCTION=1" in os.environ to
start in production mode.  This is done automatically in apps/wsgi.py.

Use ./resetdb.sh to clear the debug database (resetdb.bat on windows).
"""
import sys, os

sys.dont_write_bytecode = True

from django.core.management import execute_from_command_line

# diddle the path so it includes the dependencies
ROOT=os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0, os.path.join(ROOT, 'repos', 'bumps'))
sys.path.insert(0, ROOT)
print "=== path"
print "\n".join(sys.path)


# Run django
if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "website.settings")
    execute_from_command_line(sys.argv)
