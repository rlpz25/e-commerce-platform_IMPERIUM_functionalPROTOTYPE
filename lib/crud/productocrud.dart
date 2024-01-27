import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoCRUD{

  getProductos() async{
    return await FirebaseFirestore.instance
        .collection("productos")
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getProductoConID(int id) async {
    return await FirebaseFirestore.instance
        .collection("productos")
        .where("id", isEqualTo: id)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarProducto(String id, productoMap) async {
    FirebaseFirestore.instance
        .collection("productos")
        .doc(id)
        .set(productoMap)
        .catchError((e){
      print(e.toString());
    });
  }

  eliminarProducto(String id) async {
    FirebaseFirestore.instance
        .collection("productos")
        .doc(id)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

}