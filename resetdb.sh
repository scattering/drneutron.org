#!/bin/bash

# Remove the existing database
python manage.py cleardb

# Create an empty database.  The --noinput suppresses the request to create
# an admin user, which is instead created by the filldb command.
python manage.py syncdb --noinput

# Fill in the instruments by running apps.tracks.management.commands.filldb
# In debug mode, this also creates the default admin user
python manage.py initdb

# User profile management through userena uses migrate to create its tables
python manage.py migrate

python manage.py set_tracks

# userena requires check_permissions to set the correct table permissions
python manage.py check_permissions
