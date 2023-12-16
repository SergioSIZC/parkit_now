class Vehiculo {
  final String modelo;
  final String patente;
  final DateTime start;
  final String estado;

  const Vehiculo(
      {required this.modelo,
      required this.patente,
      required this.start,
     
      required this.estado});

  Vehiculo copy({
    String? modelo,
    String? patente,
    DateTime? start,
    DateTime? end,
    String? estado,
  }) =>
      Vehiculo(
        modelo: modelo ?? this.modelo,
        patente: patente ?? this.patente,
        start: start ?? this.start,
        estado: estado ?? this.estado,
      );
  @override
  bool operator ==(Object other)=>
      identical(this, other) ||
      other is Vehiculo &&
        runtimeType == other.runtimeType &&
        modelo == other.modelo &&
        patente == other.patente &&
        start == other.start &&
        estado == other.estado;
  @override
  int get hashCode =>modelo.hashCode ^ patente.hashCode ^start.hashCode ^ estado.hashCode;
}
