import 'package:cardgameapp/controllers/collectioncontroller.dart';
import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  late List<PlayCard> _AllCards = [];
  late Future<List> _futureCards;

  List<dynamic> get AllCards => _AllCards;

  @override
  _CollectionState createState() => _CollectionState();

  Future<List> get futureCards => _futureCards;
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._futureCards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                        height: 70,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Images/Delete_Strip.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: const Text(
                            "Check out our game concept and card examples !",
                            textScaleFactor: 1.3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Windy-Wood-Demo',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        // Important to keep as a stack to have overlay of cards.
                        child: PageView(
                          children: Covert(widget._AllCards),
                        )),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    //
    widget._futureCards = CollectionController.getCollection(widget._AllCards);
    super.initState();
  }
}

class CardView extends StatelessWidget {
  late Color color = Colors.black;
  late final PlayCard _card;

  CardView(this._card);

  PlayCard get card => _card;

  set card(PlayCard value) {
    _card = value;
  }

  CardView.Empty(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Center(
        child: Stack(children: [
          Image.asset("assets/Images/EmptyCard.png"),
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: const Center(child: CircularProgressIndicator())),
          Image.network(_card._cardUrl),
        ]),
      ),
    );
  }
}

class PlayCard {
  late String _cardUrl;
  late String _id;

  PlayCard.name(this._cardUrl);

  PlayCard(this._cardUrl, this._id);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get cardUrl => _cardUrl;

  set cardUrl(String value) {
    _cardUrl = value;
  }
}

List<CardView> Covert(List<PlayCard> AllCards) {
  List<CardView> l = [
    CardView(PlayCard.name(
        "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/CardPics%2FPage%201(upload).png?alt=media&token=0dfc687c-6fd4-46a3-92d6-92b019d287ff")),
    CardView(PlayCard.name(
        "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/CardPics%2FPage%202%20(upload).png?alt=media&token=d610b33b-8343-47c5-90c4-e86a0f9a26cb")),
    CardView(PlayCard.name(
        "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/CardPics%2FPage%203(upload).png?alt=media&token=22dbade7-629a-4a49-80a9-836b73d22eb1"))
  ];
  for (int i = 3; i < AllCards.length + 3; i++) {
    l.add(CardView(AllCards[i - 3]));
  }
  print(l.toString());
  return l;
}
