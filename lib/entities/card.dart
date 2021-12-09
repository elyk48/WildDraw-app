class Card{
  late String _cardUrl;
  late String _id;

  Card(this._cardUrl, this._id);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get cardUrl => _cardUrl;

  set cardUrl(String value) {
    _cardUrl = value;
  }
}