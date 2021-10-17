import 'dart:convert';

class FormModel {
  final String name;
  final String email;
  final int enrollmentnumber;
  final int phonenumber;
  FormModel({
    required this.name,
    required this.email,
    required this.enrollmentnumber,
    required this.phonenumber,
  });

  FormModel copyWith({
    String? name,
    String? email,
    int? enrollmentnumber,
    int? phonenumber,
  }) {
    return FormModel(
      name: name ?? this.name,
      email: email ?? this.email,
      enrollmentnumber: enrollmentnumber ?? this.enrollmentnumber,
      phonenumber: phonenumber ?? this.phonenumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'enrollmentnumber': enrollmentnumber,
      'phonenumber': phonenumber,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
      name: map['name'],
      email: map['email'],
      enrollmentnumber: map['enrollmentnumber'],
      phonenumber: map['phonenumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FormModel.fromJson(String source) =>
      FormModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FormModel(name: $name, email: $email, enrollmentnumber: $enrollmentnumber, phonenumber: $phonenumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormModel &&
        other.name == name &&
        other.email == email &&
        other.enrollmentnumber == enrollmentnumber &&
        other.phonenumber == phonenumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        enrollmentnumber.hashCode ^
        phonenumber.hashCode;
  }
}
