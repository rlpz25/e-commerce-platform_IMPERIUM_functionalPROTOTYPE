import 'package:cloud_firestore/cloud_firestore.dart';

class TarjetaCRUD{

  getTarjetas(String cliente) async{
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("tarjetas")
        .orderBy("id", descending: true)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getTarjetaConID(String cliente, String id) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("tarjetas")
        .where("id", isEqualTo: id)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarTarjeta(String cliente, String id, tarjetaMap) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("tarjetas")
        .doc(id)
        .set(tarjetaMap)
        .catchError((e){
      print(e.toString());
    });
  }

  eliminarTarjeta(String cliente, String id) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(cliente)
        .collection("tarjetas")
        .doc(id)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

}