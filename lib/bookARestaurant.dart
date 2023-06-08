// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:user_app/bookingModel.dart';
import 'package:user_app/restaurants_list.dart';

class Book_A_Restaurant extends StatefulWidget {
  final String documentId;
  // final String cat;
  const Book_A_Restaurant({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<Book_A_Restaurant> createState() => _Book_A_RestaurantState();
}

class _Book_A_RestaurantState extends State<Book_A_Restaurant> {
  final _auth = FirebaseAuth.instance;
  double _height = 0.0;
  double _width = 0.0;
  TextEditingController peopleEditingController = TextEditingController();
  TextEditingController bookingDateEditingController = TextEditingController();
  String _setTime = '', _setDate = '';

  String _hour = '', _minute = '', _time = '';

  String dateTime = '';

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  postDetailsToFirestore() async {
    print(userDocs['fullName']);
    print(resDocs['fullName']);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser!;
    BookingModel bookingModel = BookingModel();

    bookingModel.uid = FirebaseAuth.instance.currentUser!.uid;
    bookingModel.people = peopleEditingController.text;
    bookingModel.bookingDate =
        "${_dateController.text} ${_timeController.text}";
    bookingModel.userName = userDocs['fullName'];
    bookingModel.userContact = userDocs['phoneNumber'];
    bookingModel.status = 'Pending';
    bookingModel.resUid = widget.documentId;
    bookingModel.resName = resDocs['fullName'];
    bookingModel.resContact = resDocs['phoneNumber'];
    bookingModel.date =
        '${DateTime.now().day}:${DateTime.now().month}:${DateTime.now().year}/${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    bookingModel.userEmail = userDocs['email'];
    bookingModel.resEmail = resDocs['email'];

    await firebaseFirestore
        .collection('bookingRestaurant')
        .doc()
        .set(bookingModel.toMap());
    Fluttertoast.showToast(msg: "Request placed successfully");

    Navigator.pushAndRemoveUntil(
        (this.context),
        MaterialPageRoute(builder: (context) => RestaurantsList()),
        (route) => false);
  }

  var resDocs;
  var userDocs;
  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    readUser().then((value) => {
          setState(() {
            userDocs = value;
            print(value['fullName']);
          })
        });
    readRes().then((value) => {
          setState(() {
            resDocs = value;
            print(value);
          })
        });
  }

  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final people = TextFormField(
        autofocus: false,
        controller: peopleEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          peopleEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromARGB(255, 64, 156, 33),
          )),
          prefixIcon: Icon(Icons.numbers),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Number of people",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final bookingDate = TextFormField(
        autofocus: false,
        controller: bookingDateEditingController,
        keyboardType: TextInputType.datetime,
        onSaved: (value) {
          bookingDateEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromARGB(255, 64, 156, 33),
          )),
          prefixIcon: Icon(Icons.date_range),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Booking Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20,
        ),
        title: Text("Booking Details"),
        backgroundColor: Color.fromARGB(255, 64, 156, 33),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height - 120,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            people,
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: TextFormField(
                    autofocus: false,
                    controller: _dateController,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _setDate = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 64, 156, 33),
                      )),
                      prefixIcon: Icon(Icons.calendar_month),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Select Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
                // Container(
                //   width: _width / 1.7,
                //   height: _height / 9,
                //   margin: EdgeInsets.only(top: 30),
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(color: Colors.grey[200]),
                //   child: TextFormField(
                //     style: TextStyle(fontSize: 40),
                //     textAlign: TextAlign.center,
                //     enabled: false,
                //     keyboardType: TextInputType.text,
                //     controller: _dateController,
                //     onSaved: (String? val) {
                //       _setDate = val!;
                //     },
                //     decoration: InputDecoration(
                //         disabledBorder:
                //             UnderlineInputBorder(borderSide: BorderSide.none),
                //         contentPadding: EdgeInsets.only(top: 0.0)),
                //   ),
                // ),
                ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: TextFormField(
                    autofocus: false,
                    controller: _timeController,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _setTime = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 64, 156, 33),
                      )),
                      prefixIcon: Icon(Icons.timelapse),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Select Time",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
                // Container(
                //   margin: EdgeInsets.only(top: 30),
                //   width: _width / 1.7,
                //   height: _height / 9,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(color: Colors.grey[200]),
                //   child: TextFormField(
                //     style: TextStyle(fontSize: 40),
                //     textAlign: TextAlign.center,
                //     onSaved: (String? val) {
                //       _setTime = val!;
                //     },
                //     enabled: false,
                //     keyboardType: TextInputType.text,
                //     controller: _timeController,
                //     decoration: InputDecoration(
                //         disabledBorder:
                //             UnderlineInputBorder(borderSide: BorderSide.none),
                //         // labelText: 'Time',
                //         contentPadding: EdgeInsets.all(5)),
                //   ),
                // ),
                ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (selectedDate.isBefore(DateTime.now())) {
                      Fluttertoast.showToast(
                          msg: "Please Select Valid Date and Time!");
                    } else if (peopleEditingController.text.isEmpty &&
                        bookingDateEditingController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please Enter Details");
                    } else if (peopleEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter number of people");
                    } else {
                      try {
                        postDetailsToFirestore();
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Error! Can\'t Book Right now");
                      }
                    }
                  },
                  minWidth: double.infinity,
                  color: Color.fromARGB(255, 64, 156, 33),
                  height: 50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Place Booking",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future readUser() async {
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }

  Future readRes() async {
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.documentId)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }
}
