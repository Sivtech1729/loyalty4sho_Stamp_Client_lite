import 'package:flutter/material.dart';
import 'package:flutterbarber/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication.dart';


Widget drawerWidget(context) {
  return Drawer(
    child: Container(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            color: Colors.blueAccent[700],
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            child: Text(
                              "Logo",
                            ),
                            radius: 40,
                            backgroundColor: Colors.black,
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: name,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),

                    ]))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Column(
              children: <Widget>[
            GestureDetector(
            child:  Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(
                        "Logo",
                        style: TextStyle(fontSize: 10),
                      ),
                      radius: 15,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "HOME",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),onTap: ()=>Navigator.pushReplacementNamed(context, "/home"),),

                Divider(),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.star_border),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Special Offers",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, "/special"),
                ),
//
                Divider(),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_pin),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "My Profile",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, "/profileDetails"),
                ),
//
                Divider(),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "LogOut",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () async{
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context)=>LoginAndSignupPage(),
                    ), (Route<dynamic> route) => false);
                  }
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
