class Tarjeta {

  late int _id;
  late String _propietario;
  late String _numero;
  late String _mes;
  late String _anyo;
  late String _cvc;

  Tarjeta();

  Tarjeta.full(this._id, this._propietario, this._numero, this._mes, this._anyo, this._cvc);

  Tarjeta.inicializada(){
    _id = 0;
    _propietario = "";
    _numero = "";
    _mes = "";
    _anyo = "";
    _cvc = "";
  }

  String get cvc => _cvc;

  set cvc(String value) {
    _cvc = value;
  }

  String get anyo => _anyo;

  set anyo(String value) {
    _anyo = value;
  }

  String get mes => _mes;

  set mes(String value) {
    _mes = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get propietario => _propietario;

  set propietario(String value) {
    _propietario = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

}