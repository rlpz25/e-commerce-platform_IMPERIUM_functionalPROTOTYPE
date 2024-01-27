import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/clases/tarjeta.dart';
import 'package:imperium/crud/tarjetacrud.dart';

class TarjetaLocalCRUD{

  TarjetaCRUD tarjetaCRUD = TarjetaCRUD();


  List<Tarjeta> listarDirecciones(String cliente){
    List<Tarjeta> tarjetas = [];
    tarjetaCRUD.getTarjetas(cliente).then((val) {
      QuerySnapshot querySnapshot = val;
      Tarjeta tarjeta;

      for(int i=0;i < querySnapshot.docs.length;i++){
        tarjeta = Tarjeta.full(
          int.parse(querySnapshot.docs[i].id),
          querySnapshot.docs[i].get("propietario"),
          querySnapshot.docs[i].get("numero"),
          querySnapshot.docs[i].get("mes"),
          querySnapshot.docs[i].get("anyo"),
          querySnapshot.docs[i].get("cvc"),
        );
        tarjetas.add(tarjeta);
        print("Tarjeta creada");
      }
    });
    print("Devolviendo datos...");
    return tarjetas;
  }

  obtenerTarjeta(String cliente, String id){
    late Tarjeta tarjeta;
    tarjetaCRUD.getTarjetaConID(cliente, id).then((val){
      QuerySnapshot querySnapshot = val;
      if(querySnapshot.size > 0){
        tarjeta = Tarjeta.full(
          int.parse(querySnapshot.docs[0].id),
          querySnapshot.docs[0].get("propietario"),
          querySnapshot.docs[0].get("numero"),
          querySnapshot.docs[0].get("mes"),
          querySnapshot.docs[0].get("anyo"),
          querySnapshot.docs[0].get("cvc"),
        );
      } else {
        tarjeta = Tarjeta.inicializada();
      }
    });
    return tarjeta;
  }

  agregarTarjeta(String idCliente, Tarjeta tarjeta) async {
    TarjetaCRUD tarjetaCRUD = TarjetaCRUD();
    int idTarjeta = 0;
    Map<String, dynamic> tarjetaMap = {};
    await tarjetaCRUD.getTarjetas(idCliente).then((val){
      if(val != null){
        print("Hay datos");
        QuerySnapshot querySnapshot = val;
        if(querySnapshot.size != 0){
          print("Hay " + querySnapshot.size.toString() + " tarjetas");
          idTarjeta = querySnapshot.size + 1;
        }else{
          print("No hay tarjetas, se asignara como primera tarjeta");
          idTarjeta = 1;
        }
      }else{
        print("No hay datos");
        idTarjeta = 1;
      }
      tarjetaMap = {
        "id": idTarjeta,
        "propietario": tarjeta.propietario,
        "numero": tarjeta.numero,
        "mes": tarjeta.mes,
        "anyo": tarjeta.anyo,
        "cvc": tarjeta.cvc
      };
      tarjetaCRUD.agregarModificarTarjeta(idCliente, idTarjeta.toString(), tarjetaMap);
    });
  }

  agregarModificarTarjeta(String cliente, Tarjeta tarjeta){
    Map<String, dynamic> tarjetaMap = {
      "id": tarjeta.id,
      "propietario": tarjeta.propietario,
      "numero": tarjeta.numero,
      "mes": tarjeta.mes,
      "anyo": tarjeta.anyo,
      "cvc": tarjeta.cvc
    };
    tarjetaCRUD.agregarModificarTarjeta(cliente, tarjeta.id.toString(), tarjetaMap);
  }

  eliminarDireccion(String cliente, String id){
    tarjetaCRUD.eliminarTarjeta(cliente, id);
  }

}