from django.shortcuts import render
from django.http import JsonResponse
from .models import Facility

def facility_list(request):
    facilities = Facility.objects.all()
    data = [
        {
            'id': f.id,
            'name': f.name,
            'lat': float(f.latitude),
            'lng': float(f.longitude),
            'description': f.description,
            'open_time': str(f.open_time),      
            'close_time': str(f.close_time),  
            'price': f.price,
        }
        for f in facilities
    ]
    return JsonResponse(
        data,
        safe=False,
        json_dumps_params={'ensure_ascii': False},
        content_type='application/json; charset=utf-8'
    )
