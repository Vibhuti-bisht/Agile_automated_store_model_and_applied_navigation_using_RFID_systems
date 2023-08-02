// ignore_for_file: non_constant_identifier_names

class User {
  String username;
  String mobile_no;

  User(
    this.username,
    this.mobile_no,
  );
  Map<String, dynamic> toJson() =>
      {'username': username.toString(), 'mobile_no': mobile_no.toString()};
}