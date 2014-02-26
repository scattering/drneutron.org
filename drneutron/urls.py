
from django.conf.urls import patterns, url

def resolve_app(regex, urls_module):
    from django.conf.urls import include, RegexURLResolver
    urlconf_module, app_name, namespace = include(urls_module)
    return RegexURLResolver(regex, urlconf_module, 
                            app_name=app_name, namespace=namespace)

urlpatterns = []

# admin access
if True: 
    from django.contrib import admin
    admin.autodiscover()
    urlpatterns += [
        resolve_app(r'^admin/doc/', 'django.contrib.admindocs.urls'),
        resolve_app(r'^admin/', admin.site.urls),
    ]

# user signon
urlpatterns += [resolve_app(r'^accounts/', 'userena.urls')]

# tracks app
#urlpatterns += [resolve_app('^tracks/', 'tracks.urls')]

urlpatterns += [resolve_app('', 'drneutron.site.urls')]
