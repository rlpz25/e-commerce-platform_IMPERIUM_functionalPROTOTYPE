import 'package:cloud_firestore/cloud_firestore.dart';

class DireccionCRUD{

  getDirecciones(String cliente) async{
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("direcciones")
        .orderBy("id", descending: true)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getDireccionConID(String cliente, String id) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("direcciones")
        .where("id", isEqualTo: id)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarDireccion(String cliente, String id, direccionMap) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("direcciones")
        .doc(id)
        .set(direccionMap)
        .catchError((e){
      print(e.toString());
    });
  }

  eliminarDireccion(String cliente, String id) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("direcciones")
        .doc(id)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

}