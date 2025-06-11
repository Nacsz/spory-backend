from django.db import models

class Facility(models.Model):
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=255)
    latitude = models.DecimalField(max_digits=10, decimal_places=6)
    longitude = models.DecimalField(max_digits=10, decimal_places=6)
    category = models.CharField(max_length=50)
    open_time = models.TimeField()
    close_time = models.TimeField()
    price = models.IntegerField()
    description = models.TextField(blank=True)
    image = models.CharField(max_length=255, blank=True)

    def __str__(self):
        return self.name
