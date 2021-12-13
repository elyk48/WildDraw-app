import 'package:cardgameapp/controllers/collectioncontroller.dart';
import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  late List<PlayCard> _AllCards=[];
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
      if(snapshot.hasData)
      {
        return  Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Text("You have "+widget._AllCards.length.toString()+" cards in your collection",textScaleFactor: 1.3),
                Container(
                    width: MediaQuery.of(context).size.width ,
                    height: MediaQuery.of(context).size.height,
                    // Important to keep as a stack to have overlay of cards.
                    child: PageView(
                      children: Covert(widget._AllCards),
                    )
                ),
              ],
            ),
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
      }
    );
  }
  @override
  void initState(){
    //
    widget._futureCards = CollectionController.getCollection(widget._AllCards);
    super.initState();
  }
}
class CardView extends StatelessWidget {
  late Color color=Colors.black;
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
      padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                decoration: BoxDecoration(
                  color: color,
                ),
      child: Center(
        child: Stack(
            children:[
              Image.asset("assets/images/Print card.jpg"),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                  child: const Center(
                      child: CircularProgressIndicator()
                  )
              ),
              Image.network(_card._cardUrl),
            ]),
      ),
              );
  }
}
class PlayCard{
  late String _cardUrl;
  late String _id;

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

List<CardView> Covert(List<PlayCard> AllCards)
{
  List<CardView> l=[];
  for(int i=0;i<AllCards.length;i++)
    {
      l.add(CardView(AllCards[i]));
    }
  print(l.toString());
  return l;
}