import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator package

class HomePage extends StatefulWidget {
  final LatLng destination;
  const HomePage({Key? key, required this.destination}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Marker> markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> completer = Completer();
  late LatLng currentPosition;
  late final LatLng destination;

  @override
  void initState() {
    super.initState();
    destination = widget.destination;
    getCurrentLocation(); // Call method to get current location
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    addMarker(LatLng(position.latitude, position.longitude));
    addMarker(destination);
  }

  addMarker(LatLng latLng) {
    markers.add(
      Marker(
        consumeTapEvents: true,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        onTap: () {
          markers.removeWhere((element) => element.markerId == MarkerId(latLng.toString()));
          if (markers.length > 1) {
            getDirections(markers);
          } else {
            polylines.clear();
          }
          setState(() {});
        },
      ),
    );
    if (markers.length > 1) {
      getDirections(markers);
    }
    setState(() {});
  }

  getDirections(List<Marker> markers) async {
    List<LatLng> polylineCoordinates = [];
    List<PointLatLng> points = [];
    for (var i = 0; i < markers.length; i++) {
      points.add(PointLatLng(markers[i].position.latitude, markers[i].position.longitude));
    }
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAlruKgpP29ZHMwkDoBAmw7TeXKuh6QTFI',
      points.first,
      points.last,
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Accessing the late variable, which may throw LateInitializationError
      currentPosition;
      // If no error is thrown, currentPosition is initialized
      return Scaffold(
        body: Center(
          child: Stack(
            children: [
              GoogleMap(
                mapToolbarEnabled: false,
                onMapCreated: onMapCreated,
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 10,
                ),
                markers: markers.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // Handle LateInitializationError by showing a loading indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator you prefer
        ),
      );
    }
  }


}

void main() {
  runApp(MaterialApp(
    home: HomePage(destination: LatLng(41.029678, 21.329216),),
  ));
}
