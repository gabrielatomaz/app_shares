class JsonUser {
  String user;
  String photo;

  JsonUser({
    this.user,
    this.photo
  });

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    if(parsedJson == null)
      return null;

    return JsonUser(
      user: parsedJson['nomeUsuario'],
      photo: parsedJson['foto']
    );
  }
}