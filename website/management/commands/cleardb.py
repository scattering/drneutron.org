import os
from optparse import make_option

from django.core.management.base import BaseCommand, CommandError
from django.conf import settings

class Command(BaseCommand):
    args = ''
    help = "Clear the website database."
    option_list = BaseCommand.option_list + (
        make_option('--saveuser',
            action='store_true',
            dest-'saveuser',
            default=False,
            help='Preserve user table'),
    )

    def handle(self, *args, **options):
        db = settings.DATABASES['default']
        if db['ENGINE'].endswith('sqlite3'):
            if os.path.exists(db['NAME']):

                os.remove(db['NAME'])
        else:
            raise CommandError("Don't know how to clear %r"%db['ENGINE'])
