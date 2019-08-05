class User {
  String user;
  String photo;
  int idUser;
  String name;
  String role;

  User({
    this.user,
    this.photo,
    this.idUser,
    this.name,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    if(parsedJson == null)
      return null;

    return User(
      user: parsedJson['nomeUsuario'],
      photo: parsedJson['foto'],
      idUser: parsedJson['id'],
      name: parsedJson['nome'],
      role: parsedJson['cargoTipo']
    );
  }
}