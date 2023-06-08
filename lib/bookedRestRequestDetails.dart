// ignore_for_file: file_names
// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class bookedRestRequestsDetails extends StatefulWidget {
  final String documentId;
  bookedRestRequestsDetails({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<bookedRestRequestsDetails> createState() =>
      _bookedRestRequestsDetailsState();
}

class _bookedRestRequestsDetailsState extends State<bookedRestRequestsDetails> {
  var size, height, width;

  bool isLoading = false;

  String? urlfinal = null;

  String? name = null;
  // String? email = null;

  get_image(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data
    CollectionReference workers =
        FirebaseFirestore.instance.collection('bookingRestaurant');
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 64, 156, 33),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("Confirmed Bookings"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(top: 5),
                child: FutureBuilder<DocumentSnapshot>(
                  future: workers.doc(widget.documentId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something Went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Text("Data does not exists"),
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Color.fromARGB(255, 64, 156, 33),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 4)
                                ]),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "${data['resName']}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "Status: ${data['status']}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 64, 156, 33),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.description,
                                    color: Colors.white,
                                  ),
                                  title: Text("No: of people",
                                      style: TextStyle(color: Colors.white)),
                                  subtitle: Text("${data['people']}",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Divider(
                                  color: Color.fromARGB(255, 129, 209, 102),
                                ),
                                ListTile(
                                    leading: Icon(Icons.euro_outlined,
                                        color: Colors.white),
                                    title: Text(
                                      "Booking Date",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      "${data['bookingDate']}",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Divider(
                                  color: Color.fromARGB(255, 129, 209, 102),
                                ),
                                ListTile(
                                    leading: Icon(Icons.phone_android_outlined,
                                        color: Colors.white),
                                    title: Text(
                                      "Restaurant Contact",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      "${data['resContact']}",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
