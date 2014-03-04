from django.shortcuts import render_to_response
from django.template import RequestContext

def home(request):
    data = dict(app_list=[])
    context = RequestContext(request)
    return render_to_response('home.html', data, context)
