import os

from django.core.management.base import BaseCommand, CommandError
from django.conf import settings

class Command(BaseCommand):
    args = ''
    help = "Initializes the tracks database."

    def handle(self, *args, **options):
        db = settings.DATABASES['default']
        if db['ENGINE'].endswith('sqlite3'):
            if os.path.exists(db['NAME']):
                os.remove(db['NAME'])
        else:
            raise CommandError("Don't know how to clear %r"%db['ENGINE'])
