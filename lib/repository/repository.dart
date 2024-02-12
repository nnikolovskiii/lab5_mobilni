import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/exam.dart';

class Repository{
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addExam(Exam exam) async {
    try {
      db.collection('ispiti').add({
        'subject': exam.subject,
        'year': exam.year,
        'dateFrom': exam.dateFrom,
      });

    } catch (e) {
      print("Error adding user: $e");
    }
  }


  Future<List<Exam>> getAllExams() async {
    List<Exam> exams = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await db.collection("ispiti").get();
    querySnapshot.docs.forEach((doc) {
      Exam exam = Exam.fromJson(doc.data());
      exams.add(exam);
    });
    return exams;
  }

  Future<List<Exam>> getAllExamsWithStudentId(String id) async {
    List<Exam> exams = [];

    try {
      // Get the exams collection for the user with the provided email address
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
          .collection("users")
          .doc(id)
          .collection("exams")
          .get();

      querySnapshot.docs.forEach((doc) {
        exams.add(Exam.fromJson(doc.data()));
      });
    } catch (e) {
      print("Error fetching exams: $e");
    }

    return exams;
  }

  Future<void> addUser(String email, String id) async {
    try {
      db.collection('users').doc(id).set({
        'email': email,
      });

      print("User added successfully with email $email.");
    } catch (e) {
      print("Error adding user: $e");
    }
  }


  Future<void> addExamToStudent(Exam exam, String id) async {
    try {
      // Get reference to the user document
      DocumentReference userRef =
      db.collection("users").doc(id);

      // Add the exam document to the "exams" subcollection
      await userRef.collection("exams").add(exam.toJson());

      print("Exam added to user with email $id successfully.");
    } catch (e) {
      print("Error adding exam to user: $e");
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await signIn(email, password);
      await addUser(email, credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully.');
    } catch (e) {
      print('Error signing out: $e');
    }
  }


  Future<void> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

}
