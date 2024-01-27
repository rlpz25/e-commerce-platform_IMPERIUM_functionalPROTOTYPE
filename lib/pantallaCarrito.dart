import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'clases/carrito.dart';
import 'clases/producto.dart';
import 'crud/carritocrud.dart';
import 'crud/productocrud.dart';
import 'crudtolocal/carritocrudlocal.dart';

class PantallaCarrito extends StatefulWidget {
  const PantallaCarrito({Key? key}) : super(key: key);

  @override
  _PantallaCarritoState createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  @override
  void initState() {
    _getListaProductos();
    super.initState();
  }

  List<Producto> productos = [];
  Producto validador = Producto.inicializado();
  String idCarrito = "";
  bool isLoading = true;
  double total = 0;
  late Widget holder = _pantallaCarrito();

  @override
  Widget build(BuildContext context) {
    return isLoading ? PantallaEspera() : holder;
  }

  Widget _pantallaCarrito(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, position) {
                return productos.isEmpty
                    ? Container(child: Text("Carrito vacio"),)
                    : _widgetCarrito(productos[position]);
              }),
        ),
        SizedBox(
          width: double.infinity,
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                        fontSize: 25),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "\$" + total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 70, right: 70, top: 15, bottom: 15),
                    backgroundColor: const Color(0xFF192153),
                  ),
                  onPressed: () {
                    _guardarInfoCarrito().then((val){
                      Navigator.of(context).pushNamed("/Direc");
                    });
                  },
                  child: const Text(
                    "Elegir dirección de envío",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _widgetCarrito(Producto producto){

    double sub = producto.precio * producto.stock;
    int _cont = producto.stock;

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, left: 10, right: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(producto.imagen),
                    )),
                Container(
                  child: IconButton(
                    onPressed: () async {
                      holder = PantallaEspera();
                      CarritoCRUD carritoCRUD = CarritoCRUD();
                      await carritoCRUD.eliminarCarritoProducto(Constantes.miID, idCarrito, producto.id.toString()).then((val){
                        setState(() {
                          _getListaProductos();
                          holder = _pantallaCarrito();
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(right: 15),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      producto.nombre,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8, left: 10),
                              width: 120,
                              child: Text(
                                "\$ " + producto.precio.toString() + " MXN",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  child: SizedBox(
                                    width: 35,
                                    height: 32,
                                    child: OutlinedButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                        const EdgeInsets.only(right: 3),
                                      ),
                                      onPressed: () async {
                                        if (_cont > 1) {
                                          setState(() {
                                            _cont--;
                                          });
                                          Producto auxiliar = Producto.full(
                                              producto.id,
                                              producto.nombre,
                                              producto.descripcion,
                                              producto.imagen,
                                              _cont,
                                              producto.talla,
                                              producto.precio);
                                          CarritoLocalCRUD carritoLocalCRUD =
                                          CarritoLocalCRUD();
                                          await carritoLocalCRUD
                                              .agregarModificarCarritoProducto(
                                              Constantes.miID, auxiliar)
                                              .then((val) {
                                            setState(() {
                                              _getListaProductos();
                                              holder = _pantallaCarrito();
                                            });
                                            print("producto modificado");
                                          });
                                        }
                                      },
                                      child: const Center(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    _cont.toString().padLeft(
                                      2,
                                      "0",
                                    ),
                                    style:
                                    Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  margin: const EdgeInsets.only(left: 7),
                                  child: SizedBox(
                                    width: 35,
                                    height: 32,
                                    child: OutlinedButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                        const EdgeInsets.only(right: 2),
                                      ),
                                      onPressed: () async {
                                        await _getProducto(producto.id);
                                        print(_cont);
                                        print(validador.stock);
                                        if (_cont < validador.stock) {
                                          setState(() {
                                            _cont++;
                                          });
                                          Producto auxiliar = Producto.full(
                                              producto.id,
                                              producto.nombre,
                                              producto.descripcion,
                                              producto.imagen,
                                              _cont,
                                              producto.talla,
                                              producto.precio);
                                          CarritoLocalCRUD carritoLocalCRUD =
                                          CarritoLocalCRUD();
                                          await carritoLocalCRUD
                                              .agregarModificarCarritoProducto(
                                              Constantes.miID, auxiliar)
                                              .then((val) {
                                            print("producto modificado");
                                            setState(() {
                                              _getListaProductos();
                                            });
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Subtotal:"),
                                Text(
                                  "\$ " + sub.toStringAsFixed(2) + " MXN",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _calcularTotal(List<Producto> _productos) {
    total = 0;
    for (int i = 0; i < _productos.length; i++) {
      total = total + (_productos[i].precio * _productos[i].stock);
    }
  }

  _getListaProductos() async {
    print("Intentando obtener lista de carritos");
    CarritoCRUD carritoCRUD = CarritoCRUD();
    await carritoCRUD.getUltimoCarrito(Constantes.miID).then((val) async {
      print("Consultando si existe un ultimo carrito");
      if (val != null) {
        print("Se recibieron datos");
        print(val.toString());
        QuerySnapshot querySnapshot = val;
        print(querySnapshot.size);
        if (querySnapshot.size != 0) {
          print("Hay carritos");
          idCarrito = querySnapshot.docs[0].get("id").toString();
          await carritoCRUD
              .getCarritoProductos(Constantes.miID, idCarrito)
              .then((val2) async {
            print("Consultando si existen productos");
            if (val2 != null) {
              print("Se recibieron datos");
              querySnapshot = val2;
              if (querySnapshot.size != 0) {
                print("Hay productos");
                if (kDebugMode) {
                  print(val2.runtimeType);
                }
                productos.clear();
                Producto producto;
                for (int i = 0; i < querySnapshot.docs.length; i++) {
                  producto = Producto.full(
                    querySnapshot.docs[i].get("id"),
                    querySnapshot.docs[i].get("nombre"),
                    querySnapshot.docs[i].get("descripcion"),
                    querySnapshot.docs[i].get("imagen"),
                    querySnapshot.docs[i].get("cantidad"), //Se almacena en stock
                    querySnapshot.docs[i].get("talla"),
                    querySnapshot.docs[i].get("precio_unitario"), //Se almacena en precio
                  );
                  productos.add(producto);
                }
                _calcularTotal(productos);
                print(productos);
                setState(() {
                  isLoading = false;
                  holder =_pantallaCarrito();
                });
              } else {
                print("No hay productos");
                setState(() {
                  productos.clear();
                  isLoading = false;
                });
              }
            } else {
              print("No se recibieron datos");
              setState(() {
                isLoading = false;
                holder =_pantallaCarrito();
              });
            }
          });
        } else {
          print("No hay carritos");
          setState(() {
            isLoading = false;
            holder =_pantallaCarrito();
          });
        }
      } else {
        print("No se recibieron datos");
        setState(() {
          isLoading = false;
          holder =_pantallaCarrito();
        });
      }
      setState(() {
        isLoading = false;
        holder =_pantallaCarrito();
      });
    });
    setState(() {
      isLoading = false;
      holder =_pantallaCarrito();
    });
  }

  _getProducto(int id) async {
    ProductoCRUD productoCRUD = ProductoCRUD();
    await productoCRUD.getProductoConID(id).then((val) {
      if (val != null) {
        print("Hay datos");
        QuerySnapshot querySnapshot = val;
        if (querySnapshot.size != 0) {
          print("Hay productos");
          print(validador.stock);
          validador = Producto.full(
              querySnapshot.docs[0].get("id"),
              querySnapshot.docs[0].get("nombre"),
              querySnapshot.docs[0].get("descripcion"),
              querySnapshot.docs[0].get("imagen"),
              querySnapshot.docs[0].get("stock"),
              querySnapshot.docs[0].get("talla"),
              querySnapshot.docs[0].get("precio"));
          print(validador.stock);
        } else {
          print("No hay productos");
        }
      } else {
        print("No hay datos");
      }
    });
  }

  _guardarInfoCarrito() async {
    CarritoLocalCRUD carritoLocalCRUDCRUD = CarritoLocalCRUD();
    await carritoLocalCRUDCRUD.actualizarInfoUltimoCarrito(Constantes.miID, total).then((val) async {});
  }

}
