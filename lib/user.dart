class User {
  String user;
  String photo;
  int idUsuario;
  String name;
  String role;

  User({
    this.user,
    this.photo,
    this.idUsuario,
    this.name,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    if(parsedJson == null)
      return null;

    return User(
      user: parsedJson['nomeUsuario'],
      photo: parsedJson['foto'],
      idUsuario: parsedJson['id'],
      name: parsedJson['nome'],
      role: parsedJson['cargoTipo']
    );
  }
}