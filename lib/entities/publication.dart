

class Publication {
  late String _id_user;
  late String _id;
  late String _content;
  late int _likes;
  late DateTime _postedOn;
  late String _username;


  Publication(this._id_user, this._id, this._content, this._likes,
      this._postedOn, this._username);

  String get id_user => _id_user;

  set id_user(String value) {
    _id_user = value;
  }

  Publication.newPub(String content,String idUser,String username)
{
  _username = username;
  _id_user = idUser;
  _content = content;
  _likes = 0;
  _postedOn = DateTime.now();
}

  Map toJson() => {
    'id': _id_user,
    'content': _content,
    'likes': _likes,
    'postenOn': _postedOn,
  };

  String get id => _id;

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  DateTime get postedOn => _postedOn;

  set postedOn(DateTime value) {
    _postedOn = value;
  }

  int get likes => _likes;

  set likes(int value) {
    _likes = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  set id(String value) {
    _id = value;
  }
}