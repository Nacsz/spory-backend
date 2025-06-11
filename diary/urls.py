# diary/urls.py
from django.urls import path
from .views import diary_list, create_diary, diary_detail

urlpatterns = [
    path('', diary_list),                 # 전체 일지 조회
    path('create/', create_diary),        # 일지 생성
    path('<int:diary_id>/', diary_detail) # 상세 조회/수정/삭제
]
