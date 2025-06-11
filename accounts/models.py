from django.db import models

# Create your models here.
class User(models.Model):
    email = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    name = models.CharField(max_length=100)
    created_time = models.DateTimeField(auto_now_add=True)
