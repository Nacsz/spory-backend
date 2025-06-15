import 'dart:ffi';
import 'models/facility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final Location _location = Location();
  LatLng _currentPosition = const LatLng(37.5665, 126.9780);
  Facility? _selectedFacility;
  List<Facility> _facilities = [];
  Future<void> _fetchFacilitiesFromServer() async {
    print("🚀 서버 요청 시도 중...");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/facilities/'), // 💡 에뮬레이터 기준, 실기기라면 IP 변경
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _facilities = data.map((json) => Facility.fromJson(json)).toList();
          print("✅ 마커 개수: ${_facilities.length}");
        });
      } else {
        print('서버 에러: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 중 예외 발생: $e');
    }
  }

  Future<void> _showFacilitiesInBounds() async {
    final bounds = await _controller.getVisibleRegion();

    // 위도/경도 범위 안에 있는 시설만 필터링
    final visibleFacilities = _facilities.where((f) {
      final lat = f.location.latitude;
      final lng = f.location.longitude;
      return lat >= bounds.southwest.latitude &&
          lat <= bounds.northeast.latitude &&
          lng >= bounds.southwest.longitude &&
          lng <= bounds.northeast.longitude;
    }).toList();

    // 결과 출력 (BottomSheet)
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (visibleFacilities.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text("현재 화면에 보이는 시설이 없습니다."),
          );
        }
        return ListView.builder(
          itemCount: visibleFacilities.length,
          itemBuilder: (context, index) {
            final facility = visibleFacilities[index];
            return ListTile(
              title: Text(facility.name),
              subtitle: Text(facility.description),
              onTap: () {
                Navigator.pop(context); // BottomSheet 닫기
                setState(() {
                  _selectedFacility = facility;
                });
                _controller.animateCamera(
                  CameraUpdate.newLatLng(facility.location),
                );
              },
            );
          },
        );
      },
    );
  }

  Set<Marker> _createFacilityMarkers() {
    return _facilities.map((facility) {
      return Marker(
        markerId: MarkerId(facility.id),
        position: facility.location,
        infoWindow: InfoWindow(
          title: utf8.decode(utf8.encode(facility.name)),         // ✅ 여기
          snippet: utf8.decode(utf8.encode(facility.description)),
        ),
        onTap: () {
          setState(() {
            _selectedFacility = facility;
          });
        },
      );
    }).toSet();
  }



  @override
  void initState(){
    super.initState();
    _fetchFacilitiesFromServer();
  }


  Future<void> _getLocation() async{
    final hasPermission = await _location.requestPermission();
    if(hasPermission != PermissionStatus.granted) return;

    final loc = await _location.getLocation();
    print('위도: ${loc.latitude}, 경도: ${loc.longitude}');
    setState((){
      _currentPosition = LatLng(loc.latitude!, loc.longitude!);
    });

    _controller.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("현재 위치 표시")
      ),
      body: Stack(
        children: [
      GoogleMap(
      initialCameraPosition: CameraPosition(target: _currentPosition, zoom:14.0,),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _getLocation();  // 현재 위치
          _fetchFacilitiesFromServer(); // 시설 데이터
        },
        markers:{
          Marker(
            markerId:const MarkerId("currentLocation"),
            position: _currentPosition,
            infoWindow: const InfoWindow(title:"내 위치"),

          ),
          ..._createFacilityMarkers(), // 시설 마커
        },
      ),
          if (_selectedFacility != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card( // ✅ Card로 감싸줘야 함
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedFacility = null; // 카드 닫기
                            });
                          },
                        ),
                      ),
                      Text(
                        _selectedFacility!.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_selectedFacility!.description),
                      if (_selectedFacility!.openTime != null && _selectedFacility!.closeTime != null)
                        Text("⏰ ${_selectedFacility!.openTime} ~ ${_selectedFacility!.closeTime}"),
                      if (_selectedFacility!.price != null)
                        Text("💰 가격: ${_selectedFacility!.price}원"),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 10, // 카드보다 위에
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: _showFacilitiesInBounds,
              label: const Text("지도 내 시설 보기"),
              icon: const Icon(Icons.list),
            ),
          ),

        ],
      ),

    );
  }
}

