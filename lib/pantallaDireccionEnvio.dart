import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'clases/direccion.dart';
import 'crud/carritocrud.dart';
import 'crud/direccioncrud.dart';

class PantallaDireccionEnvio extends StatefulWidget {
  const PantallaDireccionEnvio({Key? key}) : super(key: key);

  @override
  _PantallaDireccionEnvioState createState() => _PantallaDireccionEnvioState();
}

class _PantallaDireccionEnvioState extends State<PantallaDireccionEnvio> {
  void initState() {
    _getTotalCarrito().then((val){
      setState(() {
        isLoading = false;
        holder = _pantallaDireccion();
      });
    });

    super.initState();
  }

  late Widget holder;
  bool isLoading = true;
  double totalCarrito = 0;
  List<Direccion> direcciones = [];

  @override
  Widget build(BuildContext context) {
    return isLoading ? const PantallaEspera() : holder;
  }

  Widget _pantallaDireccion() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF192153),
        centerTitle: true,
        title: const Text(
          "Direcciones",
          style: TextStyle(fontSize: 30, color: Colors.white, letterSpacing: 3),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: 320,
            height: 80,
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/pantallaAgregarDireccion", arguments: "/Direc");
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
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "\$" + totalCarrito.toStringAsFixed(2),
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
                      Navigator.pushNamed(context, "/PantallaPago");
                    },
                    child: const Text(
                      "Elegir tarjeta",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetDireccion(Direccion _direccion) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
      child: TextButton(
        onPressed: () {
          //metodo para la selección
        },
        child: Row(
          children: [
            Radio(
              value: _direccion.id,
              groupValue: Constantes.control,
              onChanged: (T) {
                setState(() {
                  Constantes.control = _direccion.id;
                  holder = _pantallaDireccion();
                });
              },
            ),
            Column(
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
                  _direccion.ciudad +
                      ", " +
                      _direccion.estado +
                      ", Col: " +
                      _direccion.colonia,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _direccion.calle +
                      ", " +
                      _direccion.no_interior +
                      ", CP: " +
                      _direccion.codpost,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getListaDirecciones() async {
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
        } else {
          print("No hay direcciones");
        }
      } else {
        print("No hay datos");
      }
    });
  }

  _getTotalCarrito() async {
    print("Intentando obtener lista de carritos");
    CarritoCRUD carritoCRUD = CarritoCRUD();
    await carritoCRUD.getUltimoCarrito(Constantes.miID).then((val) async {
      print("Consultando si existe un ultimo carrito");
      if (val != null) {
        print("Se recibieron datos");
        QuerySnapshot querySnapshot = val;
        if (querySnapshot.size != 0) {
          print("Hay carritos");
          totalCarrito = querySnapshot.docs[0].get("total") as double;
          await _getListaDirecciones().then((val){
            setState(() {
              isLoading = false;
              holder =_pantallaDireccion();
            });
          });
        } else {
          print("No hay carritos");
          setState(() {
            isLoading = false;
            holder =_pantallaDireccion();
          });
        }
      } else {
        print("No se recibieron datos");
        setState(() {
          isLoading = false;
          holder =_pantallaDireccion();
        });
      }
      setState(() {
        isLoading = false;
        holder =_pantallaDireccion();
      });
    });
    setState(() {
      isLoading = false;
      holder =_pantallaDireccion();
    });
  }

}
