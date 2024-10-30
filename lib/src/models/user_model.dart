class UserModel {
  String fullname;
  String email;
  String userID;
  String role;
  String registerDate;

  UserModel({
    required this.userID,
    required this.email,
    required this.fullname,
    required this.role,
    required this.registerDate,
  });

  Map<String, dynamic> toMap() => {
        'user_id': userID,
        'email': email,
        'role': role,
        'register_date': registerDate,
        'fullname': fullname,
      };

  factory UserModel.fromMap(dynamic map) {
    return UserModel(
      userID: map['user_id'],
      email: map['email'],
      fullname: map['fullname'],
      role: map['role'],
      registerDate: map['register_date'],
    );
  }

}
