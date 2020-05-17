class DateList {
  List<Date> dates;

  DateList({this.dates});

  DateList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      dates = new List<Date>();
      json['data'].forEach((v) {
        dates.add(new Date.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dates != null) {
      data['data'] = this.dates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Date {
  String dbDate;
  String hour;
  int tutorId;

  Date({this.dbDate, this.hour, this.tutorId});

  Date.fromJson(Map<String, dynamic> json) {
    dbDate = json['db_date'];
    hour = json['hour'];
    tutorId = json['tutor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['db_date'] = this.dbDate;
    data['hour'] = this.hour;
    data['tutor_id'] = this.tutorId;
    return data;
  }
}
