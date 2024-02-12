import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/repository/repository.dart';

import '../firebase_options.dart';
import '../model/exam.dart';
import 'grid_view_user_screen.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  Repository repository = Repository();
  late Future<List<Exam>> examsFuture;

  @override
  void initState() {
    super.initState();
    examsFuture = repository.getAllExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam List'),
      ),
      body: FutureBuilder<List<Exam>>(
        future: examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Exam> exams = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    String id = "";
                    if (FirebaseAuth.instance.currentUser != null) {
                      id= FirebaseAuth.instance.currentUser?.uid ?? "";
                    }
                    repository.addExamToStudent(exams[index], id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourWidgetUser()), // Replace YourOtherScreen() with the screen you want to navigate to
                    );
                  },
                  child: GridTile(
                    child: Container(
                      color: Colors.blueGrey[100],
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display subject name in bold
                          Text(
                            exams[index].subject,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5), // Add space between subject and date/time
                          // Display date and time in gray
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
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  void printExam(Exam exam) {
    print('Exam: ${exam.subject}, Date: ${exam.dateFrom}, Year: ${exam.year}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Repository repository = new Repository();

  await repository.signUp("test2@gmail.com", "Nikola09875!");
  runApp(MaterialApp(
    home: YourWidget(),
  ));
}
