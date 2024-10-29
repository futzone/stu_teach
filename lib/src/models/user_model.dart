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
}
