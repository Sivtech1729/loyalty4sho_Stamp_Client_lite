import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class ScanCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanCodeScreenState();
  }
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length != 0)
      return documents[0];
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Pay Loyalty',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load.
            return new Container(
              child: new Center(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            );
          // Shows the real data with the data retrieved.
          else if (snapshot.hasData) {
            DocumentSnapshot response = snapshot.data;
            print(response);

            if (response != null)
              return Container(
                  color: Colors.blueAccent[700],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(top: 25),
                                width: 250,
                                height: 350,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Show this screen to the cashier at the\npoint of sale to earn loyalty points",
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                    QrImage(
                                      data: jsonEncode({
                                        "data": response.data,
                                        "id": response.documentID
                                      }),
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),

//                          Text("52 31 354"),
//                          Text("wiCode", style: TextStyle(fontSize: 14,color: Colors.grey),)
                                  ],
                                ),
                              ),
                              Container(
                                child: CircleAvatar(
                                  child: Text(
                                    "Logo",
                                  ),
                                  radius: 25,
                                  backgroundColor: Colors.black,
                                ),
                                alignment: Alignment.center,
                              )
                            ])
                      ]));
            else
              return Center(
                child: Text('Unable To Get Your Profile'),
              );
          } else {
            return Center(
              child: Text('Unable To Get Your Profile'),
            );
          }
        },
      ),
    );
  }
}
