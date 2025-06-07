class Note {
  int? id;
  late String title, description, createOn;

  Note(this.title, this.description) {
    createOn = DateTime.now().toString();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": title,
      "description": description,
      "createOn": createOn
    };

    if(id != null) {
      map["id"] = id;
    }

    return map;
  }
}