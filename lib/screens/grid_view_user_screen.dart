import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/repository/repository.dart';
import 'package:lab3/screens/grid_view_screen.dart';
import 'package:lab3/screens/login_screen.dart';

import '../calendar/pages/events_example.dart';
import '../calendar/utils.dart';
import '../firebase_options.dart';
import '../model/exam.dart';
import 'events_screen.dart';

class YourWidgetUser extends StatefulWidget {
  YourWidgetUser();

  @override
  _YourWidgetUserState createState() => _YourWidgetUserState();
}

class _YourWidgetUserState extends State<YourWidgetUser> {
  Repository repository = Repository();
  late Future<List<Exam>> examsFuture;
  String id = "";

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      id = FirebaseAuth.instance.currentUser?.uid ?? "";
      examsFuture = repository.getAllExamsWithStudentId(id);
    } else {
      examsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? username = FirebaseAuth.instance.currentUser?.displayName;
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exam List'),
        actions: [
          if (isLoggedIn)
            TextButton(
              onPressed: () async {
                await repository.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.black),
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.black),
              ),
            ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp1()),
              );
            },
            child: Text(
              'Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourWidget()),
              );
            },
            icon: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: isLoggedIn ? buildExamList() : Container(), // Render exam list only if logged in
    );
  }

  Widget buildExamList() {
    return FutureBuilder<List<Exam>>(
      future: examsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          LinkedHashMap<DateTime, List<Event>> eventsMap =
          convertExamsToMap(snapshot.data!);
          return TableEventsExample(kEvents: eventsMap);
        }
      },
    );
  }


  LinkedHashMap<DateTime, List<Event>> convertExamsToMap(List<Exam> exams) {
    LinkedHashMap<DateTime, List<Event>> resultMap = LinkedHashMap();

    for (var exam in exams) {
      DateTime examDate = exam.dateFrom;
      if (resultMap.containsKey(examDate)) {
        resultMap[examDate]?.add(Event('${exam.subject} | ${exam.dateFrom.hour}:${exam.dateFrom.minute}'));
      } else {
        resultMap[examDate] = [Event('${exam.subject} | ${exam.dateFrom.hour}:${exam.dateFrom.minute}')];
      }
    }

    return resultMap;
  }

  void printExam(Exam exam) {
    print(
        'Exam: ${exam.subject}, Date: ${exam.dateFrom}, Year: ${exam.year}');
  }
}
