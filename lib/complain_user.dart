class ComplainUser {
  String user;
  String photo;
  String reason;
  int idComplaiment;
  int idUsuer;

  ComplainUser({
    this.user,
    this.photo,
    this.reason,
    this.idComplaiment,
    this.idUsuer
  });

  factory ComplainUser.fromJson(Map<String, dynamic> parsedJson) {
    if(parsedJson == null)
      return null;

    return ComplainUser(
      user: parsedJson['nomeUsuario'],
      photo: parsedJson['foto'],
      idComplaiment: parsedJson['idDenuncia'],
      idUsuer: parsedJson['idUsuario'],
      reason: parsedJson['motivo'] 
    );
  }
}