import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/repository/repository.dart';
import 'package:lab3/screens/grid_view_screen.dart';
import 'package:lab3/screens/login_screen.dart';

import '../firebase_options.dart';
import '../model/exam.dart';

class YourWidgetUser extends StatefulWidget {
  YourWidgetUser();

  @override
  _YourWidgetUserState createState() => _YourWidgetUserState();
}

class _YourWidgetUserState extends State<YourWidgetUser> {
  Repository repository = Repository();
  late Future<List<Exam>> examsFuture;
  String id = "";

  _YourWidgetUserState();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam List'),
        actions: [
          if (FirebaseAuth.instance.currentUser != null)
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
      body: FutureBuilder<List<Exam>>(
        future: examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Exam> exams = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: GridTile(
                    child: Container(
                      color: Colors.yellow[100],
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exams[index].subject,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              text: 'Date: ',
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: '${exams[index].dateFrom.toString()}',
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Year: ',
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: '${exams[index].year}',
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text(FirebaseAuth.instance.currentUser != null
                    ? 'No exams available'
                    : 'No user signed in'));
          }
        },
      ),
    );
  }

  void printExam(Exam exam) {
    print('Exam: ${exam.subject}, Date: ${exam.dateFrom}, Year: ${exam.year}');
  }
}
