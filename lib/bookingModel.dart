import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? uid;
  String? people;
  String? bookingDate;
  String? userName;
  String? userContact;
  String? status;
  String? resUid;
  String? resName;
  String? resContact;
  String? date;
  String? userEmail;
  String? resEmail;

  BookingModel({
    this.uid,
    this.people,
    this.bookingDate,
    this.userName,
    this.userContact,
    this.status,
    this.resUid,
    this.resName,
    this.resContact,
    this.date,
    this.userEmail,
    this.resEmail,
  });

  // receiving data from server
  factory BookingModel.fromMap(map) {
    return BookingModel(
      uid: map['uid'],
      people: map['people'],
      bookingDate: map['bookingDate'],
      userName: map['userName'],
      userContact: map['userContact'],
      resName: map['resName'],
      resContact: map['resContact'],
      status: map['status'],
      resUid: map['resUid'],
      date: map['date'],
      userEmail: map['userEmail'],
      resEmail: map['resEmail'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'people': people,
      'bookingDate': bookingDate,
      'userName': userName,
      'userContact': userContact,
      'status': status,
      'resUid': resUid,
      'resName': resName,
      'resContact': resContact,
      'date': date,
      'userEmail': userEmail,
      'resEmail': resEmail,
    };
  }
}
