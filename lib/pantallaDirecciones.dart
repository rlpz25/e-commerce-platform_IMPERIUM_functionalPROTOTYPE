import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/widgets/widgets.dart';
import 'clases/direccion.dart';
import 'crud/direccioncrud.dart';

class Direcciones extends StatefulWidget {
  const Direcciones({Key? key}) : super(key: key);

  @override

  _DireccionesState createState() => _DireccionesState();
}

class _DireccionesState extends State<Direcciones> {

  void initState() {
    _getListaDirec();
    holder = _pantallaDireccion();
    super.initState();
  }

  late Widget holder;
  bool isLoading = true;
  List<Direccion> direcciones = [];

  @override
  Widget build(BuildContext context) {
    return isLoading ? const PantallaEspera() : holder;
  }

  Widget _pantallaDireccion() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          width: 320,
          height: 80,
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/pantallaAgregarDireccion", arguments: "/pantallaPrincipalCliente");
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0XFFEEEEEE),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Agregar nueva dirección",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              )),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: ListView.builder(
                itemCount: direcciones.length,
                itemBuilder: (context, position) {
                  return direcciones.isEmpty
                      ? Container()
                      : _widgetDireccion(direcciones[position]);
                }),
          ),
        ),
      ],
    );
  }

  Widget _widgetDireccion(Direccion _direccion) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      child: TextButton(
        style: TextButtonMyStyle(),
        onPressed: () {
          //metodo para la selección
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: Column(
            //aqui van los spacer que dice el Beto xD
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _direccion.nombre,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                _direccion.ciudad +", "+ _direccion.estado +", Col: "+ _direccion.colonia,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                _direccion.calle +", "+ _direccion.no_interior +", CP: "+ _direccion.codpost,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getListaDirec() async {
    print("Intentando obtener lista de direcciones");
    DireccionCRUD direccionCrud = DireccionCRUD();
    await direccionCrud.getDirecciones(Constantes.miID).then((val) async {
      print("Intentando obtener datos");
      if (val != null) {
        print("Hay Datos");
        QuerySnapshot querySnapshot = val;
        if (querySnapshot.size != 0) {
          print("Hay direcciones");
          Direccion direccion;
          for (int i = 0; i < querySnapshot.docs.length; i++) {
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
          setState(() {
            isLoading = false;
            holder = _pantallaDireccion();
          });
        } else {
          print("No hay direcciones");
          setState(() {
            isLoading = false;
            holder = _pantallaDireccion();
          });
        }
      } else {
        print("No hay datos");
        setState(() {
          isLoading = false;
          holder = _pantallaDireccion();
        });
      }
    });
  }
}
