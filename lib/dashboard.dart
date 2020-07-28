import 'package:flutter/rendering.dart';
import 'package:flutterbarber/ui/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePag extends StatefulWidget {
  HomePag({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePagState createState() => _HomePagState();
}

class _HomePagState extends State<HomePag> {
  DocumentSnapshot userDocument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .157,
                  color: Colors.white,
                ),
                Positioned(
                  top: 20,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueAccent[700],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: Text("Logo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text('Welcome back',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                      Text(
                          userDocument != null
                              ? userDocument.data["Name"] +
                                  " " +
                                  userDocument.data["Surname"]
                              : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: userDocument != null
                  ? buildCardsList()
                  : [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent[700],
        child: Icon(FontAwesomeIcons.dollarSign),
        onPressed: () {
          Navigator.pushNamed(context, "/scan");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          child: BottomAppBar(
            color: Colors.white10,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.dehaze,
                      color: Colors.blueAccent[700],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/special");
                    },
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.black45,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.blueAccent[700],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/profileDetails");
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildCardsList() {
    List<Widget> lstCards = List();
    List<CardType> lstGetCards = CardType.getCards();
    for (CardType card in lstGetCards) {
      lstCards.add(makeCard(card,
          cardCt: userDocument.data.containsKey("Loyalty_Card_${card.id}_st")
              ? userDocument.data["Loyalty_Card_${card.id}_st"]
              : 0));
    }
    return lstCards;
  }

  makeCard(CardType card, {int cardCt = 0}) {
    return Stack(
      children: <Widget>[
        AspectRatio(
            aspectRatio: 0.95,
            child: Container(
              color: Colors.white,
            )),
        Positioned(
          top: 90,
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blueAccent[700],
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  height: 170,
                  width: MediaQuery.of(context).size.width * .9,
                  image: AssetImage(card.imageUrl != null
                      ? card.imageUrl
                      : "assets/barber1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(card.cardTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
              ),
              Text('Earn free gents cut & finish clipper',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: MediaQuery.of(context).size.height * .12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: FittedBox(
                    child: Text(
                      'Earn free gents cut & finish clipper Earn free gents',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Lets Apply',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: makeDots(cardCt))
              ],
            ),
          ),
        )
      ],
    );
  }

  makeDots(int fillDots) {
    List<Widget> lstDots = List();
    for (int i = 0; i < 10; i++) {
      lstDots.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Icon(
          i < fillDots ? FontAwesomeIcons.solidCircle : FontAwesomeIcons.circle,
          color: Colors.white,
          size: 20,
        ),
      ));
    }
    return lstDots;
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email");
    if (email != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .getDocuments();

      DocumentSnapshot document = result.documents[0];
      print('result:${document.exists}');
      if (document != null) {
        setState(() {
          userDocument = document;
        });
      }
    }
  }
}

class CardType {
  int id;
  String name;
  String cardTitle;
  String cardShortDesc;
  String cardDesc;
  String imageUrl;

  CardType(this.id, this.name,
      {this.cardTitle, this.cardShortDesc, this.cardDesc, this.imageUrl});

  static List<CardType> getCards() {
    return <CardType>[
      CardType(1, 'Blow Dry',
          cardTitle: "Blow Dry Card", imageUrl: "assets/barber1.jpg"),
      CardType(2, 'Colour',
          cardTitle: "Color Card", imageUrl: "assets/barber2.jpg"),
      CardType(3, 'Product',
          cardTitle: "Product Card", imageUrl: "assets/barber3.jpg"),
      CardType(4, 'Gents',
          cardTitle: "Gents Card", imageUrl: "assets/barber1.jpg"),
      CardType(5, 'Nails Card',
          cardTitle: "Nails Card", imageUrl: "assets/barber4.jpg"),
    ];
  }
}
