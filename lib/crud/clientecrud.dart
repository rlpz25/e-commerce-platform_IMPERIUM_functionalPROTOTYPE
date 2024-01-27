import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteCRUD{

  getClientes() async{
    return await FirebaseFirestore.instance
        .collection("clientes")
        .get()
        .then((value){
          print("Clientes solicitados a la base de datos");
    }).catchError((e){
          print("Error al obtener clientes");
      print(e.toString());
    });
  }

  getClienteConID(String idCliente) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .where("id", isEqualTo: idCliente)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getClienteConCorreo(String correoCliente) async {
    return await FirebaseFirestore.instance
        .collection("clientes")
        .where("correo", isEqualTo: correoCliente)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  agregarModificarCliente(String idCliente, clienteMap) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .set(clienteMap)
        .catchError((e){
       print(e.toString());
    });
  }

  eliminarCliente(String idCliente) async {
    FirebaseFirestore.instance
        .collection("clientes")
        .doc(idCliente)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }

}