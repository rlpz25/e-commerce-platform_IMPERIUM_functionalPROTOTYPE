import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/clases/cliente.dart';
import 'package:imperium/crud/clientecrud.dart';

class ClientelocalCRUD{

  ClienteCRUD clienteCRUD = ClienteCRUD();

  List<Cliente> listarClientes(){
    List<Cliente> clientes = [];
    clienteCRUD.getClientes().then((val) {
      QuerySnapshot querySnapshot = val;
      Cliente cliente;
      for(int i=0;i < querySnapshot.docs.length;i++){
        cliente = Cliente.full(
            querySnapshot.docs[i].id,
            querySnapshot.docs[i].get("nombre"),
            querySnapshot.docs[i].get("apellido"),
            querySnapshot.docs[i].get("correo"),
            querySnapshot.docs[i].get("telefono"));
        clientes.add(cliente);
        print("Cliente creado");
      }
    });
    print("Devolviendo datos...");
    return clientes;
  }

  Future<Cliente> obtenerCliente (String id) async{
    late Cliente cliente;
    clienteCRUD.getClienteConID(id).then((val){
      QuerySnapshot querySnapshot = val;
      if(querySnapshot.size > 0){
        cliente = Cliente.full(
            querySnapshot.docs[0].id,
            querySnapshot.docs[0].get("nombre"),
            querySnapshot.docs[0].get("apellido"),
            querySnapshot.docs[0].get("correo"),
            querySnapshot.docs[0].get("telefono"));
        } else
          cliente = Cliente.clienteId("No existe");
    });
    return cliente;
  }

  obtenerClienteCorreo(String correo){
    late Cliente cliente;
    clienteCRUD.getClienteConCorreo(correo).then((val){
      QuerySnapshot querySnapshot = val;
      if(querySnapshot.size > 0){
        cliente = Cliente.full(
            querySnapshot.docs[0].id,
            querySnapshot.docs[0].get("nombre"),
            querySnapshot.docs[0].get("apellido"),
            querySnapshot.docs[0].get("correo"),
            querySnapshot.docs[0].get("telefono"));
      } else
        cliente = Cliente.clienteId("No existe");
    });
    return cliente;
  }

  agregarModificarCliente(Cliente cliente){
    Map<String, dynamic> clienteMap = {
      "id": cliente.id,
      "nombre": cliente.nombre,
      "apellido": cliente.apellido,
      "telefono": cliente.telefono,
      "correo": cliente.correo
    };
    clienteCRUD.agregarModificarCliente(cliente.id, clienteMap);
  }

  eliminarCliente(String id){
    clienteCRUD.eliminarCliente(id);
  }

}