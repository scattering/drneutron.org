
from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()
urlpatterns = patterns(
    'website.views',
    r'^accounts/', include('userena.urls'),
    r'^admin/doc/', include('django.contrib.admindocs.urls'),
    r'^admin/', include('django.contrib.admin.site.urls'),

    # welcome page for launching apps
    url('^$', 'home'),
    )
