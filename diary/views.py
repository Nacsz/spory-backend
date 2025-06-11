from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .models import Diary
from .serializers import DiarySerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def diary_list(request):
    diaries = Diary.objects.filter(user=request.user).order_by('-created_time')
    serializer = DiarySerializer(diaries, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_diary(request):
    serializer = DiarySerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def diary_detail(request, diary_id):
    try:
        diary = Diary.objects.get(id=diary_id, user=request.user)
    except Diary.DoesNotExist:
        return Response({'message': '일지를 찾을 수 없습니다.'}, status=404)

    if request.method == 'GET':
        serializer = DiarySerializer(diary)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = DiarySerializer(diary, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    
    elif request.method == 'DELETE':
        diary.delete()
        return Response({'message': '삭제 완료'})
