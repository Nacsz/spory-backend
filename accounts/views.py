from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken


@api_view(['POST'])
def login_view(request):
  user_id = request.data.get('id')
  password = request.data.get('password')



  user = authenticate(request, username=user_id, password = password)

  if user is not None:
    refresh = RefreshToken.for_user(user)
    return Response({'message': '로그인 성공',
                      'token' : str(refresh.access_token),
                      'refresh_token' : str(refresh),
                      'user_id' : user.id})
  
  else:
    return Response({'message' : '아이디 또는 비밀번호가 틀렸습니다'}, status = 400)


@api_view(['POST'])
def register_view(request):
  user_id = request.data.get('id')
  password = request.data.get('password')
  name = request.data.get('name')

  if User.objects.filter(username = user_id).exists():
    return Response({'message' : '이미 존재하는 사용자입니다.'}, status = 400)
  
  user = User.objects.create_user(
    username = user_id,
    password = password,
    first_name = name
  )

  return Response({'message': '회원가입 완료', 'user_id' : user.id})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def my_info_view(request):
  user = request.user
  return Response({
    'user_id': user.id,
    'email': user.username,  # 우리가 username에 email을 저장했기 때문
    'name': user.first_name,
    'joined': user.date_joined
})

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_user_view(request):
  user = request.user

  name = request.data.get('name')
  password = request.data.get('password')
  email = request.data.get('email')

  if name:
    user.first_name = name
  
  if password:
    user.set_password(password)

  if email:
    user.username = email

  user.save()

  return Response({'message': '회원정보가 수정되었습니다.'})


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_user_view(request):
  request.user.delete()
  return Response({"messeage" : "삭제가 완료되었습니다."})


# Create your views here.
