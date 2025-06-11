from django.urls import path
from .views import login_view, register_view, my_info_view, update_user_view, delete_user_view


urlpatterns = [
  path('login/',login_view),
  path('register/', register_view),
  path('me/', my_info_view),
  path('me/update/', update_user_view),
  path('me/delete/', delete_user_view),

]