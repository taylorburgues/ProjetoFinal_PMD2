class ctcData {
  int id;
  String nome;
  String data;

  ctcData(this.id, this.nome, this.data);

  Map toJson() => {'id': id, 'nome': nome, 'data': data};

  factory ctcData.fromJson(dynamic json) {
    if (json['data'] == null) json['data'] = "01/01/2022 00:00:01";
    //if (json['log'] == null) json['log'] = '0';

    return ctcData(json['id'] as int, json['nome'] as String,
        json['data'] as String);
  }
  @override
  String toString() {
    // TODO: implement toString
    return '{${this.id}, ${this.nome},${this.data}}';
  }
}


/*class ctcData {
  String id;
  String nome;

  ctcData(this.id, this.nome);

  Map toJson() => {'id': id, 'nome': nome, };
  
  factory ctcData.fromJson(dynamic json) {
    if (json['id'] == null) json['id'] = '0';
    if (json['nome'] == null) json['nome'] = '0';

    return ctcData(json['id'] as String, json ['nome'] as String);
  }

  @override
  String toString() {
  return '{${this.id}, {${this.nome}';}
}*/
