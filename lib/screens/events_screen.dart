import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../maps/main.dart';


class MyEvent {
  final String name;
  final double latitude;
  final double longitude;

  MyEvent({required this.name, required this.latitude, required this.longitude});
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventsListPage(),
    );
  }
}

class EventsListPage extends StatelessWidget {
  final List<MyEvent> events = [
    MyEvent(name: 'Event 1', latitude: 41.029678, longitude: 21.329216),
    MyEvent(name: 'Event 2', latitude: 41.34514, longitude: 21.55504),
    MyEvent(name: 'Event 3', latitude:41.11722, longitude: 20.80194),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(destination: LatLng(events[index].latitude, events[index].longitude),)),
              );
            },
            child: EventCard(event: events[index]),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final MyEvent event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(event.name),
        subtitle: Text('Lat: ${event.latitude}, Lon: ${event.longitude}'),
      ),
    );
  }
}
