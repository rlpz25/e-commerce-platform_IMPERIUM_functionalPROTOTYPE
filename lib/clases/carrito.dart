class Carrito {
  late int _id;
  late double _total;
  late bool _ultimo;
  late bool _finalizado;

  Carrito();

  Carrito.full(this._id, this._total, this._finalizado, this._ultimo);

  Carrito.inicializado(){
    _id = 0;
    _total = 0;
    _ultimo = false;
    _finalizado = false;
  }

  bool get finalizado => _finalizado;

  set finalizado(bool value) {
    _finalizado = value;
  }

  bool get ultimo => _ultimo;

  set ultimo(bool value) {
    _ultimo = value;
  }

  double get total => _total;

  set total(double value) {
    _total = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

}