import 'package:flutter/material.dart';

class friendInfo extends StatelessWidget {


  final String _id;
  final String _image;
  final String _username;
  final String _Rank;
  final String _Level;


  friendInfo(this._id, this._image, this._username, this._Rank, this._Level);

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: InkWell(
        onTap: () async {

        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.network(_image, width: 200, height: 94),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_username),
                const SizedBox(
                  height: 10,
                ),
                Text( "Rank :"+_Rank , textScaleFactor: 2)
              ],
            )
          ],
        ),
      ),
    );;
  }
}
