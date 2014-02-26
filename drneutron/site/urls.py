
from django.conf.urls import patterns, url

urlpatterns = patterns('drneutron.site.views',
    url('^$', 'home'),
    )
