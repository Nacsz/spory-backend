from django.urls import path
from .views import facility_list

urlpatterns = [
    path('api/facilities/', facility_list),
]
