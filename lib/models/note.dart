class Note {
  int _id;
  String _title;
  String _text;
  String _date;

  Note(this._title, this._text, this._date);
  Note.withId(this._id, this._title, this._text, this._date);

  //getters
  int get id => _id;
  String get title => _title;
  String get text => _text;
  String get date => _date;

  //setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set text(String newText) {
    if (newText.length <= 2000) {
      this._text = newText;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set id(int newId) {
    this._id = newId;
  }

  //convert Note object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['text'] = _text;
    map['date'] = _date;

    return map;
  }

  //convert Map object to Note object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._text = map['text'];
    this._date = map['date'];
  }
}
