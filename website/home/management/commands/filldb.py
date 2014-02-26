from django.core.management.base import BaseCommand, CommandError

class Command(BaseCommand):
    args = ''
    help = "Initializes the tracks database."

    def handle(self, *args, **options):
        set_domain()
        set_default_admin_user()
        #set_tracks()


def set_domain():
    from django.contrib.sites.models import Site
    from django.conf import settings

    site = Site.objects.get_current()
    site.domain = settings.SITE_DOMAIN
    site.name = settings.SITE_NAME
    site.save()

def set_default_admin_user():
    from django.conf import settings
    from django.contrib.auth import models as auth_models
    from django.contrib.auth.management import create_superuser

    # only create default admin in debug mode, not in production mode.
    if settings.DEBUG:
        try:
            auth_models.User.objects.get(username='admin')
        except auth_models.User.DoesNotExist:
            print '*' * 80
            print 'Creating admin user -- login: admin, password: admin'
            print '*' * 80
            assert auth_models.User.objects.create_superuser('admin', '', 'admin')
        else:
            print 'Admin user already exists.'

def set_tracks():
    import json
    from django.conf import settings
    from tracks.models import populate_instruments
    populate_instruments(json.load(settings.TRACKS_FACILITY_FILE))
