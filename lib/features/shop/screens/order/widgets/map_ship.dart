import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';

class MapShip extends StatefulWidget {
  const MapShip({super.key});

  @override
  State<MapShip> createState() => _MapShipState();
}

class _MapShipState extends State<MapShip> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(10.7769, 106.7009);
  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  void _initMapData() {
    const LatLng startPoint = LatLng(10.7825, 106.6855);
    const LatLng shipperPoint = LatLng(10.7750, 106.7020);
    const LatLng endPoint = LatLng(10.7735, 106.7250);

    _markers['start'] = Marker(
      markerId: const MarkerId('start'),
      position: startPoint,
      infoWindow: const InfoWindow(title: 'Cửa hàng/Điểm đi'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    _markers['shipper'] = Marker(
      markerId: const MarkerId('shipper'),
      position: shipperPoint,
      infoWindow: const InfoWindow(title: 'Shipper đang di chuyển'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    _markers['end'] = Marker(
      markerId: const MarkerId('end'),
      position: endPoint,
      infoWindow: const InfoWindow(title: 'Điểm giao hàng'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    _polylines.add(
      const Polyline(
        polylineId: PolylineId('route'),
        visible: true,
        points: [startPoint, shipperPoint, endPoint],
        color: Colors.indigo,
        width: 5,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: _markers.values.toSet(),
            polylines: _polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white.withOpacity(0.9),
              child: SafeArea(
                bottom: false,
                child: UAppBar(
                  showBackArrow: true,
                  title: const Text(
                    'Live Tracking',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.15,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                mapController.animateCamera(CameraUpdate.newLatLng(_center));
              },
              child: const Icon(Icons.my_location, color: Colors.black54),
            ),
          ),
          Positioned(
            left: 16,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text('Đang giao hàng', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delivery_dining, color: Colors.indigo, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Đơn hàng đang được giao đến bạn',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dự kiến giao: 14:30 - 15:00',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}