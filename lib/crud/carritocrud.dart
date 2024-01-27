import 'package:cloud_firestore/cloud_firestore.dart';

class CarritoCRUD{

  getCarritos(String idCliente) async{
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getCarritoProductos(String idCliente, String idCarrito) async{
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .doc(idCarrito)
        .collection("productos")
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getCarritoConID(String idCliente, String idCarrito) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .where("id", isEqualTo: idCarrito)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getUltimoCarrito(idCliente) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .where("ultimo", isEqualTo: true)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getCarritosPendientes(String idCliente) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .where("finalizado", isEqualTo: false)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarCarrito(String idCliente, String idCarrito, carritoMap) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .doc(idCarrito)
        .set(carritoMap)
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarCarritoProducto(String idCliente, int idCarrito, int idProducto, productoMap) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .doc(idCarrito.toString())
        .collection("productos")
        .doc(idProducto.toString())
        .set(productoMap)
        .then((value) {
          print("Producto agregado");
    }).catchError((e){
      print(e.toString());
    });
  }

  eliminarCarrito(String idCliente, String idCarrito) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .doc(idCarrito)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

  eliminarCarritoProducto(String idCliente, String idCarrito, String idProducto) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .collection("carritos")
        .doc(idCarrito)
        .collection("productos")
        .doc(idProducto)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

}