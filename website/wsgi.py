import os

ROOT = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

# manage.py sets up the python environment, but doesn't run a management
# command unless it is run from the command line.
execfile(os.path.join(ROOT, 'manage.py'))

sys.stdout = sys.stderr

# Since we are running from wsgi, we are in production mode
os.environ['DJANGO_PRODUCTION'] = '1'
import django.core.handlers.wsgi as wsgi
application = wsgi.WSGIHandler()
