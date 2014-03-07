from django.shortcuts import render_to_response
from django.template import RequestContext

def home(request):
    apps = [
        '/tracks/project/view/',
        ]
    data = dict(apps=apps,
                #menu=(('#','submenu',(('#','test 1'),('#','test 2'))),),
               )
    context = RequestContext(request)
    return render_to_response('home.html', data, context)
