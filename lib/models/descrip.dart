
class Descripcion {
  final String nombre;
  final String ubi;
  final String desc;
  final int num;
  final String fotos;

  Descripcion(
      {required this.nombre,
      required this.ubi,
      required this.desc,
      required this.num,
      required this.fotos});

  factory Descripcion.fromJson(Map<String, dynamic> json) {
    return Descripcion(
      nombre: json['nombre'] as String,
      ubi: json['ubi'] as String,
      desc: json['desc'] as String,
      num: json['num'] as int,
      fotos: json['fotos'] as String,
    );
  }

  @override
  String toString() {
    return 'Restaurante {nombre: $nombre, ubi: $ubi, desc: $desc, num: $num, fotos: $fotos}';
  }
}
