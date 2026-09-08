class Patrimonio {
  int? id;
  String nome;
  String descricao;
  String local;
  String responsavel;

  Patrimonio({
    this.id,
    required this.nome,
    required this.descricao,
    required this.local,
    required this.responsavel,
  });

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    return Patrimonio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      local: json['local'],
      responsavel: json['responsavel'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}