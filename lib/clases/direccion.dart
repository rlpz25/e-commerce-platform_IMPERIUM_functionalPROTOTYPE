class Direccion {

  late int _id;
  late String _nombre;
  late String _telefono;
  late String _pais;
  late String _estado;
  late String _ciudad;
  late String _colonia;
  late String _calle;
  late String _no_interior;
  late String _codpost;

  Direccion();

  Direccion.full(this._id, this._nombre, this._telefono, this._pais, this._estado, this._ciudad, this._colonia, this._calle, this._no_interior, this._codpost);

  Direccion.inicializada(){
    _id = 0;
    _nombre = "";
    _telefono = "";
    _pais = "";
    _estado = "";
    _ciudad = "";
    _colonia = "";
    _calle = "";
    _no_interior = "";
    _codpost = "";
  }

  String get codpost => _codpost;

  set codpost(String value) {
    _codpost = value;
  }

  String get no_interior => _no_interior;

  set no_interior(String value) {
    _no_interior = value;
  }

  String get calle => _calle;

  set calle(String value) {
    _calle = value;
  }

  String get colonia => _colonia;

  set colonia(String value) {
    _colonia = value;
  }

  String get ciudad => _ciudad;

  set ciudad(String value) {
    _ciudad = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get pais => _pais;

  set pais(String value) {
    _pais = value;
  }

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

}