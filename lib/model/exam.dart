import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  String subject;
  DateTime dateFrom;
  int year;

  Exam({
    required this.subject,
    required this.dateFrom,
    required this.year,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      subject: json['subject'] as String,
      dateFrom: _parseDate(json['dateFrom']),
      year: json['year'] as int,
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    if (dateString is String) {
      // Parse the string and convert it to a DateTime
      return DateTime.tryParse(dateString) ?? DateTime.now();
    } else if (dateString is Timestamp) {
      // If the date is already a Timestamp, convert it to a DateTime
      return dateString.toDate();
    } else {
      // Default fallback value
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'dateFrom': dateFrom.toIso8601String(),
      'year': year,
    };
  }

  @override
  String toString() {
    return 'Exam{subject: $subject, dateFrom: $dateFrom, year: $year}';
  }
}
