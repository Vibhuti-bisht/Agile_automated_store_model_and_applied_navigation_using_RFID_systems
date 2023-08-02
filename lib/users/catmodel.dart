// ignore_for_file: non_constant_identifier_names

class CatUser{
  String category;

  CatUser(
    this.category,
  );
  Map<String, dynamic> toJson() => {'category': category.toString()};
}
