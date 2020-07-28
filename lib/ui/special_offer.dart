import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialOfferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SpecialOfferPageState();
  }
}

class _SpecialOfferPageState extends State<SpecialOfferPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getData() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('offer').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length != 0)
      return documents[0].data;
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Special Offers",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: drawerWidget(context),
      body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              // Shows progress indicator until the data is load.
              return new Container(
                child: new Center(
                  child: Text('No Current Deals', style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              );
            // Shows the real data with the data retrieved.
            else if (snapshot.hasData) {
              var response = snapshot.data;
              print(response);

              if (response != null)
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Check out some of our current deals\nrunning in our stores",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 50,
                        height: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          child:
                          ListView(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Image.network(
                                      response['ImageUrl1'],
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      response['ImageUrl2'],
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      response['ImageUrl3'],
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      response['ImageUrl4'],
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      response['ImageUrl5'],
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                    ),
                                  ],
                                ),
                              ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              else
                return Center(
                  child: Text('Unable To Get Your Profile'),
                );
            } else {
              return Center(
                child: Text('Unable To Get Your Profile'),
              );
            }
          }),
    );
  }
}
