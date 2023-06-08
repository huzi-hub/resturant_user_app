// ignore_for_file: camel_case_types, must_be_immutable, unused_local_variable

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter_map_launcher/flutter_map_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user_app/bookARestaurant.dart';
import 'package:user_app/bookin_details/bookin_details_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:user_app/booking_details/booking_details_widget.dart';

class RestaurantDetails extends StatefulWidget {
  final String documentId;
  RestaurantDetails({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  var size, height, width;

  bool isLoading = false;

  String? urlfinal = null;

  String? name = null;
  String? A = null;
  String? makeCall = null;
  final TextEditingController _messageController = TextEditingController();

  get_image(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('restaurantsProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  // void intiState() {
  //   super.initState();

  //   workers.doc(widget.documentId).get().then((value) {
  //     get_image(value['email']).then((value) {
  //       setState(() {
  //         urlfinal = value;
  //       });
  //     });
  //   });
  // }

  CollectionReference workers =
      FirebaseFirestore.instance.collection('restaurants');
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
        title: Text("Profile"),
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
                      void _handleBookNowButton() async {
                        final phoneNumber = data[
                            'phoneNumber']; // Replace with the desired phone number

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Ensure the parameter type is 'BuildContext'
                            return AlertDialog(
                              title: Text('Enter your message'),
                              content: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                    hintText: 'Enter your message'),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    final message = _messageController.text;
                                    final encodedMessage =
                                        Uri.encodeComponent(message);
                                    final whatsappUrl =
                                        "https://wa.me/$phoneNumber?text=$encodedMessage";
                                    launch(whatsappUrl);
                                  },
                                  child: Text('Send'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      A = data['fullName'];
                      makeCall = data['phoneNumber'];

                      // get_image(data['email']);
                      // setState(() {
                      //   get_image(data['email']);
                      // });

                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.tealAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 4)
                                ]),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "${data['fullName']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Restuarant Name: ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "${data['address']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "Contact: ${data['phoneNumber']}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                color: Colors.white,
                child: Column(
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => UserApp()));
                    //     },
                    //     minWidth: double.infinity,
                    //     color: Color.fromARGB(255, 64, 156, 33),
                    //     height: 50,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         // const Text(
                    //         //   "Book Now",
                    //         //   style: TextStyle(
                    //         //       color: Colors.white,
                    //         //       fontSize: 18,
                    //         //       fontWeight: FontWeight.w700,
                    //         //       letterSpacing: 3),
                    //         // ),

                    //       ],
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () => MapsLauncher.launchQuery("${A}"),
                      child: Text(
                        'See Direction',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final whatsappUrl = "https://wa.me/$makeCall";
                        launch(whatsappUrl);
                      },
                      child: Text(
                        'WhatsApp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: () =>
                          FlutterPhoneDirectCaller.callNumber("${makeCall}"),
                      child: Text(
                        'Make Call',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => notificationwid(),
                    //       ),
                    //     );
                    //   },
                    //   child: Text(
                    //     'Book Now',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w700,
                    //       letterSpacing: 3,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 8,
                      width: 15,
                    ),
                    // ElevatedButton(
                    //   onPressed: () =>
                    //       FlutterPhoneDirectCaller.callNumber("${makeCall}"),
                    //   child: Text(
                    //     'Book Restaurant',
                    //     style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w700,
                    //         letterSpacing: 3),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Book_A_Restaurant(
                                      documentId: widget.documentId)));
                        },
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
