import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class LoginAndSignupPage extends StatefulWidget {
  const LoginAndSignupPage();
  @override
  _LoginAndSignupPage createState() => _LoginAndSignupPage();
}

class _LoginAndSignupPage extends State<LoginAndSignupPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool pass = true, confirm_password = true;
  TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String name,
      surName,
      dob,
      phone,
      email,
      gender,
      password,
      confirm,
      _currentItemSelected = "Male";
  final _signupFormKey = GlobalKey<FormState>();
  bool _progress = false;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  void _showSnackBar(message) {
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(message),
        duration: Duration(seconds: 5),
      )
    );
  }

  Widget loginPage() {
    return Stack(
      children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _loginFormKey,
          child: ListView(
            children: <Widget>[
              // SizedBox(height: 15,),

              // Container(
              //   child: CircleAvatar(
              //     child: Text("Logo",),
              //     radius: 40,
              //     backgroundColor: Colors.black,
              //   ),
              //   padding: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.white,
              //   ),
              // ),

              SizedBox(height: 10,),

              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  onSaved: (value) => email = value,
                  validator: (value) {
                    if (value.isEmpty || value == null)
                      return "Invalid Email";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value == null)
                      return "Invalid password";
                    return null;
                  },
                  onSaved: (value) => password = value,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
              ),

              SizedBox(height: 10,),

              GestureDetector(
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.red,),
                ),
                onTap: () => Navigator.pushNamed(context, "/forgot"),
              ),

              SizedBox(height: 20,),

              _progress
                ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                  : ButtonTheme(
                      child: RaisedButton(
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        onPressed: () {
                          if (!_loginFormKey.currentState.validate()) {
                            return;
                          }
                          setState(() {
                            _progress = true;
                          });
                          _loginFormKey.currentState.save();
                          login(email: email.trim(), password: password)
                                .then((res) {
                              if (res['success']) {
                                setState(() {
                                  _progress = true;
                                });
                                Navigator.pushReplacementNamed(
                                        context, "/home");
                              } else {
                                setState(() {
                                  _progress = false;
                                });
                                _showSnackBar(res['message']);
                              }
                            });
                          },
//            onPressed: () => Navigator.pushReplacementNamed(context, "/menu"),
//                onPressed: ()=>_loginFormStore.validateAll(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Sign In with Email",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    ]);
  }

  Future login({email, password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    if (check) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        if (user.user.isEmailVerified) {
          print('success');
          successful = true;
          prefs.setString('email', email);
        } else {
          print('failed');
          message = 'Kindly activate your email';
        }
      }).catchError((onError) {
        print("error $onError");
        message = 'Invalid email or password';
      });
    } else {
      message = 'Kindly check your internet connection!';
    }
    return {'success': successful, 'message': message};
  }

  Widget signupPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Form(
          key: _signupFormKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "LET\'S GET YOU SIGNNED UP!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || value == null)
                      return "Kindly enter your name";
                  },
                  onSaved: (value) => name = value,
                  decoration: InputDecoration(
                    hintText: "Name",
//                            errorText: store.error.firstName
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value == null)
                        return "Kindly enter your surname";
                    },
                    onSaved: (value) => surName = value,
                    decoration: InputDecoration(
                      hintText: "Surname",
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                    validator: (value) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                      if (value.trim().isEmpty || !regex.hasMatch(value)) {
                        return 'Please enter valid email address';
                      }
                    },
                    onSaved: (value) => email = value,
                    decoration: InputDecoration(
                      hintText: "Email",
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value.isEmpty || value == null)
                      return "Kindly enter your phone number";
                    else if (int.tryParse(value) == null) {
                      return "Kindly enter valid phone number";
                    }
                  },
                  onSaved: (value) => phone = value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45.0,
                decoration: ShapeDecoration(
                  shape: Border(
                      bottom: BorderSide(width: 0.5, style: BorderStyle.solid)),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
//                    alignedDropdown: true,
                      child: new DropdownButton<String>(
                          items: <String>[
                            'Male',
                            'Female',
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected;
                            });
                          },
                          hint: Text("Gender"),
                          value: _currentItemSelected)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DateTimeField(
                onSaved: (value) => dob = value.toString(),
                validator: (value) {
                  if (value == null) return "Kindly choose your date of birth";
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Password must be atleast 8 characters long.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  obscureText: pass,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8)
                      return "Password must be 8 characters long";
                  },
                  onSaved: (value) => password = value,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: pass ?Colors.grey[400]:Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              pass = !pass;
                            });
                          })),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.black),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || value != _passwordController.text) {
                      return "Password doesn't match";
                    }
                  },
                  onSaved: (value) => confirm = value,
                  obscureText: confirm_password,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: confirm_password?Colors.grey[400]:Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          confirm_password = !confirm_password;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _progress
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ButtonTheme(
                      child: RaisedButton(
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        onPressed: () {
                          if (!_signupFormKey.currentState.validate()) {
                            return;
                          }
                          setState(() {
                            _progress = true;
                          });
                          _signupFormKey.currentState.save();

                          signup(
                                  email: email.trim().toLowerCase(),
                                  password: password..trim().toLowerCase())
                              .then((res) {
                            print(res['success']);
                            if (res['success']) {
                              addUserInfo(
                                      email: email,
                                      dob: dob,
                                      gender: _currentItemSelected,
                                      name: name,
                                      surname: surName,
                                      phone: phone)
                                  .then((e) {
                                print(e.toString());
                                if (e['success']) {
                                  setState(() {
                                    _progress = false;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, "/home");
                                } else {
                                  setState(() {
                                    _progress = false;
                                  });
                                  _showSnackBar(e['message']);
                                }
                              });
                            } else {
                              setState(() {
                                _progress = false;
                              });
                              _showSnackBar(res['message']);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "CREATE ACCOUNT",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      minWidth: MediaQuery.of(context).size.width,
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Colors.black45,
                Color(0xFF6427FF),
                Color(0xFF6427FF)
              ]
            ),
          ),
        ),
        DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldkey,
            body: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
              child: Column(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      child: Text("Logo",),
                      radius: 40,
                      backgroundColor: Colors.black,
                    ),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(text: "SING IN",),
                      Tab(text: "SIGN UP",)
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [loginPage(), signupPage()],
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Stack(
  //       children: <Widget>[
  //         Container(
  //           width: double.infinity,
  //           height: double.infinity,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Colors.black45,
  //                 Color(0xFF6427FF)
  //               ]
  //             ),
  //           ),
  //         ),
  //         Scaffold(
  //           backgroundColor: Colors.transparent,
  //             // backgroundColor:  Colors.blueAccent[700],
  //             key: _scaffoldkey,
  //             appBar: PreferredSize(
  //                 child: Container(
  //                   margin: EdgeInsets.only(top: 20),
  //                   child: TabBar(
  //                     indicatorColor: Colors.white,
  //                     labelColor: Colors.white,
  //                     tabs: [
  //                       Tab(
  //                         text: "SING IN",
  //                       ),
  //                       Tab(
  //                         text: "SIGN UP",
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 preferredSize: Size(100, 200)),
  //             body: TabBarView(
  //               children: [loginPage(), signupPage()],
  //             )),
  //       ],
  //     ),
  //   );
  // }

  Future<bool> checkInternet() async {
    try {
      final result1 = await http
          .read('https://jsonplaceholder.typicode.com/todos/1')
          .timeout(const Duration(seconds: 5));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future addUserInfo({
    name,
    surname,
    phone,
    dob,
    email,
    gender,
  }) async {
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;

    if (check) {
      try {
        final QuerySnapshot result =
            await Firestore.instance.collection('users').getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        print(documents.isEmpty);
//        if (documents.length != 0) {
//          await Firestore.instance
//              .collection('users')
//              .document(documents[0].documentID)
//              .updateData({
//            'updated': DateTime.now().millisecondsSinceEpoch.toString(),
//            'email': email,
//            'Name': name,
//            'Surname':surname,
//            'DoB': dob,
//            'Gender': gender,
//          }).then((value) {
//            successful = true;
//          });
//        } else {
        await Firestore.instance.collection('users').document().setData({
          'created': DateTime.now().millisecondsSinceEpoch.toString(),
          'CustID': documents.length + 1,
          'email': email,
          'Name': name,
          'Surname': surname,
          'DoB': dob,
          'Gender': gender,
          'cell': phone,
          'Loyalty-Points': 0,
          "Transactions": []
        }).then((value) {
          successful = true;
        });
//        }
      } catch (e) {}
    } else {
      message = 'Kindly check your internet connection!';
    }
    return {'success': successful, 'message': message};
  }

  Future signup({email, password}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    if (check) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print('start');
        print(user);
        print('start');
        if (!user.user.isEmailVerified) {
          user.user.sendEmailVerification();
          successful = true;
          prefs.setString("email", email);
        }
      }).catchError((onError) {
        print("error $onError");
        message = 'The email address is already in use by another account.';
      });
    } else {
      message = 'Kindly check your internet connection!';
    }
    return {'success': successful, 'message': message};
  }
}
