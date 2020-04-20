class SubjectsList {
  List<Subject> subjects;

  SubjectsList({this.subjects});

  SubjectsList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      subjects = new List<Subject>();
      json['data'].forEach((v) {
        subjects.add(new Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subjects != null) {
      data['data'] = this.subjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subject {
  int id;
  String name;
  String level;

  Subject({this.id, this.name, this.level});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['level'] = this.level;
    return data;
  }
}
