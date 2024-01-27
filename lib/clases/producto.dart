class Producto{

  late int _id;
  late double _precio;
  late String _nombre;
  late String _descripcion;
  late String _imagen;
  late int _stock;
  late String _talla;

  Producto();

  Producto.full(int id, String nombre, String descripcion, String imagen, int stock, String talla, double precio){
    this._id = id;
    this._nombre = nombre;
    this._descripcion = descripcion;
    this._imagen = imagen;
    this._stock = stock;
    this._talla = talla;
    this._precio = precio;
  }

  Producto.inicializado(){
    this._id = 0;
    this._nombre = "";
    this._descripcion = "";
    this._imagen = "";
    this._stock = 0;
    this._talla = "";
    this._precio = 0;
  }

  String get talla => _talla;

  set talla(String value) {
    _talla = value;
  }

  int get stock => _stock;

  set stock(int value) {
    _stock = value;
  }

  String get imagen => _imagen;

  set imagen(String value) {
    _imagen = value;
  }

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  double get precio => _precio;

  set precio(double value) {
    _precio = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

}