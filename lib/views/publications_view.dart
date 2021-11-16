import 'package:cardgameapp/entities/publication.dart';
import 'package:flutter/material.dart';

class PublicationView extends StatefulWidget {
  const PublicationView({Key? key}) : super(key: key);

  @override
  _PublicationViewState createState() => _PublicationViewState();
}

class _PublicationViewState extends State<PublicationView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  FutureBuilder<Publication> FBPublication(Future<Publication> p)
  {
    return FutureBuilder(
      future: p,
      builder: (context,snapshot){
        if(snapshot.hasData)
        {
          return Text(snapshot.data!.id);
        }
        else {
          return const Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }
}
