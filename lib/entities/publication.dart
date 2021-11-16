

class Publication {
  late String _id_user;
  late String _content;
  late int _likes;
  late DateTime _postedOn;
  late String _username;

  Publication(
      this._id_user, this._content, this._likes, this._postedOn, this._username);
Publication.newPub(String content,String idUser,String username)
{
  _username = username;
  _id_user = idUser;
  _content = content;
  _likes = 0;
  _postedOn = DateTime.now();
}

  @override
  String toString() {
    return 'Publication{_id: $_id_user, _content: $_content, _likes: $_likes, _postedOn: $_postedOn, _username: $_username}';
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

  String get id => _id_user;

  set id(String value) {
    _id_user = value;
  }


  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get id_user => _id_user;

  set id_user(String value) {
    _id_user = value;
  }

  Map toJson() => {
    'id': _id_user,
    'content': _content,
    'likes': _likes,
    'postenOn': _postedOn,
  };
}