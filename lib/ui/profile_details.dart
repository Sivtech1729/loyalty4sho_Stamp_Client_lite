import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class ProfileDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsPageState();
  }
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  String dob, name, surName,cell;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _progress = false;

  final _updateFormKey = GlobalKey<FormState>();
  int gender;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future update(String userId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({"Name": name,"Surname":surName,"cell":cell,'DoB':dob,"Gender":gender==0?"Male":"Female"}).then((v) {
          showInSnackBar("Profile successfully updated");
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
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
      key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "PROFILE DETAILS",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                // Shows progress indicator until the data is load.
                return new Container(
                  child: new Center(
                    child: new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                );
              // Shows the real data with the data retrieved.
              else if (snapshot.hasData) {
                DocumentSnapshot document = snapshot.data;
                var response = document.data;
                print(response);

                if (response != null) {
                  gender = response['Gender'] == 'Male' ? 0 : 1;
                  name = response['Name'];
                  surName = response['Surname'];
                  cell = response['cell'];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "NAME",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          TextFormField(
                            initialValue: name,
                            decoration: InputDecoration(
                              hintText: "Name",
                            ),
                            validator: (e) {
                              if (e.isEmpty) return "Name can not be empty";
                            },
                            onSaved: (e) => name = e,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "SURNAME",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          TextFormField(
                            initialValue: surName,
                            decoration: InputDecoration(hintText: "Surname"),
                            validator: (e) {
                              if (e.isEmpty) return "Surname can not be empty";
                            },
                            onSaved: (e) => surName = e,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "MOBILE NUMBER",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          TextFormField(
                            initialValue: cell.toString(),
                            decoration:
                                InputDecoration(hintText: "+27 63 588 6"),
                            validator: (e) {
                              if (e.isEmpty)
                                return "Number can not be left empty";
                              else if (e.length != 10)
                                return "Number must contain 10 digits";
                            },
                            onSaved: (e) => cell =e,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "EMAIL ADDRESS",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            response['email'],
//                          decoration:
//                              InputDecoration(
//
//                                  hintText: "Reshams@gmail.com"),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "DATE OF BIRTH",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          DateTimeField(
                            initialValue: DateTime.parse(response['DoB']),
                            onSaved: (value) => dob = value.toString(),
                            validator: (value) {
                              if (value == null)
                                return "Kindly choose your date of birth";
                            },
                            decoration: InputDecoration(hintText: "DOB"),
                            format: DateFormat("yyyy-MM-dd"),
                            readOnly: true,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
//                        TextField(
//                          decoration: InputDecoration(hintText: ""),
//                        ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "GENDER",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: gender,
                                onChanged: (val) {
                                  setState(() {
                                    gender = val;
                                  });
                                },
                                activeColor: Colors.black,
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: gender,
                                onChanged: (val) {
                                  print(val);
                                  setState(() {
                                    gender = val;
                                  });
                                },
                                activeColor: Colors.black,
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _progress
                              ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              if (!_updateFormKey.currentState.validate()) {
                                return;
                              }
                              setState(() {
                                _progress = true;
                              });
                              _updateFormKey.currentState.save();
                              update(document.documentID).then((res) {
                                setState(() {
                                  _progress = false;
                                });
                              });
                            },
                            child: Text(
                              "SAVE DETAILS",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.black,
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // RaisedButton(
                          //   padding: EdgeInsets.symmetric(vertical: 15),
                          //   onPressed: () {},
                          //   child: Text(
                          //     "REMOVE",
                          //     style: TextStyle(color: Colors.white, fontSize: 20),
                          //   ),
                          //   color: Colors.blue,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      key: _updateFormKey,
                    ),
                  );
                } else
                  return Center(
                    child: Text('Unable To Get Your Profile'),
                  );
              } else {
                return Center(
                  child: Text('Unable To Get Your Profile'),
                );
              }
            }));
  }
}
