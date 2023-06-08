import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ApiIntegrationWidget extends StatefulWidget {
  @override
  _ApiIntegrationWidgetState createState() => _ApiIntegrationWidgetState();
}

class _ApiIntegrationWidgetState extends State<ApiIntegrationWidget> {
  String? budget;
  String? people;
  String? cuisines;
  List<String> responseList = [];
  bool _showNoItemsWidget = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    try {
      responseList.clear();
      Dio dio = Dio();
      Response response = await dio.get(
        'https://fyp-app.1r46k2soa5v86.ap-south-1.cs.amazonlightsail.com/predict?',
        queryParameters: {
          'budget': '$budget',
          'People': '$people',
          'Cuisines': '$cuisines'
        },
        options: Options(
          headers: {'Content-Type': 'Application/json'},
        ),
      );
      if (response.statusCode == 200) {
        responseList.add(response.data['predictions_1']);
        responseList.add(response.data['predictions_2']);
        responseList.add(response.data['predictions_3']);
        setState(() {});
      } else {
        _showNoItemsWidget = true;
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
      _showNoItemsWidget = true;
      setState(() {});
    }
  }

  void launchMaps(String location) {
    MapsLauncher.launchQuery(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predict Restaurants'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: budget,
            onChanged: (String? newValue) {
              setState(() {
                budget = newValue;
              });
            },
            items: <String>['1000', '2000', '3000']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Select budget'),
          ),
          DropdownButton<String>(
            value: people,
            onChanged: (String? newValue) {
              setState(() {
                people = newValue;
              });
            },
            items: <String>['1', '2', '3', '4', '5']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Select number of people'),
          ),
          DropdownButton<String>(
            value: cuisines,
            onChanged: (String? newValue) {
              setState(() {
                cuisines = newValue;
              });
            },
            items: <String>['BBQ', 'Italian', 'Mexican', 'Chinese']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text('Select cuisine'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_isLoading) {
                if (budget == null || budget!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    showCustomSnackbar(
                        'Please select budget.', Colors.orange[800]!),
                  );
                } else if (people == null || people!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    showCustomSnackbar(
                        'Please select number of people.', Colors.orange[800]!),
                  );
                } else if (cuisines == null || cuisines!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    showCustomSnackbar(
                        'Please select cuisine.', Colors.orange[800]!),
                  );
                } else {
                  setState(() {
                    _isLoading = true;
                  });

                  _submitForm().whenComplete(() {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  showCustomSnackbar(
                      'Please wait for the previous request to complete.',
                      Colors.green),
                );
              }
            },
            child: Text('Submit'),
          ),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 10),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : !_showNoItemsWidget
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: responseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(08),
                              ),
                              elevation: 10,
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/pngegg.png',
                                  height: 25,
                                  width: 25,
                                ),
                                title: Text(
                                  responseList[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    String location = responseList[index];
                                    MapsLauncher.launchQuery(location);
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text('No restaurants found.'),
                      ),
                    ),
        ],
      ),
    );
  }

  SnackBar showCustomSnackbar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
