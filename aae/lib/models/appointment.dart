class AppointmentsList {
  List<Appointment> appointment;

  AppointmentsList({this.appointment});

  AppointmentsList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      appointment = new List<Appointment>();
      json['data'].forEach((v) {
        appointment.add(new Appointment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointment != null) {
      data['data'] = this.appointment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Appointment {
//   int id;
//   int subjectId;
//   int userId;
//   String email;
//   String name;
//   String date;
//   String hour;
//   String address;

//   Appointment(
//       {this.id,
//       this.subjectId,
//       this.userId,
//       this.email,
//       this.name,
//       this.date,
//       this.hour,
//       this.address});

//   Appointment.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     subjectId = json['subject_id'];
//     userId = json['user_id'];
//     email = json['email'];
//     name = json['name'];
//     date = json['date'];
//     hour = json['hour'];
//     address = json['address'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['subject_id'] = this.subjectId;
//     data['user_id'] = this.userId;
//     data['email'] = this.email;
//     data['name'] = this.name;
//     data['date'] = this.date;
//     data['hour'] = this.hour;
//     data['address'] = this.address;
//     return data;
//   }
// }

class Appointment {
  int id;
  int subjectId;
  String subjectName;
  String date;
  String hour;
  int studentId;
  int tutorId;
  String name;
  String email;
  String address;

  Appointment(
      {this.id,
      this.subjectId,
      this.subjectName,
      this.date,
      this.hour,
      this.studentId,
      this.tutorId,
      this.name,
      this.email,
      this.address});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    date = json['date'];
    hour = json['hour'];
    studentId = json['student_id'];
    tutorId = json['tutor_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['date'] = this.date;
    data['hour'] = this.hour;
    data['student_id'] = this.studentId;
    data['tutor_id'] = this.tutorId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}