import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/clases/direccion.dart';
import 'package:imperium/crud/direccioncrud.dart';

class DireccionLocalCRUD{

  DireccionCRUD direccionCRUD = DireccionCRUD();


  List<Direccion> listarDirecciones(String cliente){
    List<Direccion> direcciones = [];
    direccionCRUD.getDirecciones(cliente).then((val) {
      QuerySnapshot querySnapshot = val;
      Direccion direccion;

      for(int i=0;i < querySnapshot.docs.length;i++){
        direccion = Direccion.full(
          int.parse(querySnapshot.docs[i].id),
          querySnapshot.docs[i].get("nombre"),
          querySnapshot.docs[i].get("telefono"),
          querySnapshot.docs[i].get("pais"),
          querySnapshot.docs[i].get("estado"),
          querySnapshot.docs[i].get("ciudad"),
          querySnapshot.docs[i].get("colonia"),
          querySnapshot.docs[i].get("calle"),
          querySnapshot.docs[i].get("no_interior"),
          querySnapshot.docs[i].get("codpost"),
        );
        direcciones.add(direccion);
        print("Direccion creada");
      }
    });
    print("Devolviendo datos...");
    return direcciones;
  }

  obtenerDireccion(String cliente, String id){
    late Direccion direccion;
    direccionCRUD.getDireccionConID(cliente, id).then((val){
      QuerySnapshot querySnapshot = val;
      if(querySnapshot.size > 0){
        direccion = Direccion.full(
          int.parse(querySnapshot.docs[0].id),
          querySnapshot.docs[0].get("nombre"),
          querySnapshot.docs[0].get("telefono"),
          querySnapshot.docs[0].get("pais"),
          querySnapshot.docs[0].get("estado"),
          querySnapshot.docs[0].get("ciudad"),
          querySnapshot.docs[0].get("colonia"),
          querySnapshot.docs[0].get("calle"),
          querySnapshot.docs[0].get("no_interior"),
          querySnapshot.docs[0].get("codpost"),
        );
      } else {
        direccion = Direccion.inicializada();
      }
    });
    return direccion;
  }

  agregarDireccion(String idCliente, Direccion direccion) async {
    DireccionCRUD tarjetaCRUD = DireccionCRUD();
    int idDireccion = 0;
    Map<String, dynamic> direccionMap = {};
    await tarjetaCRUD.getDirecciones(idCliente).then((val){
      if(val != null){
        print("Hay datos");
        QuerySnapshot querySnapshot = val;
        if(querySnapshot.size != 0){
          print("Hay " + querySnapshot.size.toString() + " direcciones");
          idDireccion = querySnapshot.size + 1;
        }else{
          print("No hay direcciones, se asignara como primera direccion");
          idDireccion = 1;
        }
      }else{
        print("No hay datos");
        idDireccion = 1;
      }
      direccionMap = {
        "id": idDireccion,
        "nombre": direccion.nombre,
        "telefono": direccion.telefono,
        "pais": direccion.pais,
        "estado": direccion.estado,
        "ciudad": direccion.ciudad,
        "colonia": direccion.colonia,
        "calle": direccion.calle,
        "no_interior": direccion.no_interior,
        "codpost": direccion.codpost
      };
      direccionCRUD.agregarModificarDireccion(idCliente, idDireccion.toString(), direccionMap);
    });
  }

  agregarModificarDireccion(String cliente, Direccion direccion){
    Map<String, dynamic> direccionMap = {
      "id": direccion.id,
      "nombre": direccion.nombre,
      "telefono": direccion.telefono,
      "pais": direccion.pais,
      "estado": direccion.estado,
      "ciudad": direccion.ciudad,
      "colonia": direccion.colonia,
      "calle": direccion.calle,
      "no_interior": direccion.no_interior,
      "codpost": direccion.codpost
    };
    direccionCRUD.agregarModificarDireccion(cliente, direccion.id.toString(), direccionMap);
  }

  eliminarDireccion(String cliente, String id){
    direccionCRUD.eliminarDireccion(cliente, id);
  }

}