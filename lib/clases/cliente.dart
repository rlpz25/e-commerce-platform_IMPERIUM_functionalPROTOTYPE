class Cliente{

  late String _id = "";
  late String _nombre = "";
  late String _apellido = "";
  late String _correo = "";
  late String _telefono = "";

  Cliente();

  Cliente.full(this._id, this._nombre, this._apellido, this._correo, this._telefono);

  Cliente.clienteId(this._id);

  Cliente.inicializado(){
    _id = "";
    _nombre = "";
    _apellido = "";
    _correo = "";
    _telefono = "";
  }

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
  }

  String get correo => _correo;

  set correo(String value) {
    _correo = value;
  }

  String get apellido => _apellido;

  set apellido(String value) {
    _apellido = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}