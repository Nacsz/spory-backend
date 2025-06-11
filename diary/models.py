from django.db import models
from django.contrib.auth.models import User
from facilities.models import Facility
from reservations.models import Reservation

class Diary(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    reservation = models.ForeignKey(Reservation, on_delete=models.SET_NULL, null=True, blank=True)
    facility = models.ForeignKey(Facility, on_delete=models.SET_NULL, null=True, blank=True)
    title = models.CharField(max_length=255)
    content = models.TextField()
    created_time = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
