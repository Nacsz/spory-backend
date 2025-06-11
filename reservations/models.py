# reservations/models.py
from django.db import models
from django.contrib.auth.models import User
from facilities.models import Facility

class Reservation(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    facility = models.ForeignKey(Facility, on_delete=models.CASCADE)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    status = models.CharField(max_length=50)
