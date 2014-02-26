
from django.conf.urls import patterns, url

urlpatterns = patterns('website.home.views',
    url('^$', 'home'),
    )
