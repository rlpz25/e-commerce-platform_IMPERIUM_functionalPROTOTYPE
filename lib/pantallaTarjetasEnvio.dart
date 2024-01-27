import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'clases/tarjeta.dart';
import 'crud/carritocrud.dart';
import 'crud/tarjetacrud.dart';

class PantallaTarjetasEnvio extends StatefulWidget {
  const PantallaTarjetasEnvio({Key? key}) : super(key: key);

  @override
  _PantallaTarjetasEnvioState createState() => _PantallaTarjetasEnvioState();
}

class _PantallaTarjetasEnvioState extends State<PantallaTarjetasEnvio> {
  @override
  void initState() {
    _getTotalCarrito();
    super.initState();
  }

  late Widget holder = Container();
  bool isLoading = true;
  double totalCarrito = 0;
  List<Tarjeta> tarjetas = [];
  dynamic refresh;

  @override
  Widget build(BuildContext context) {
    return isLoading ? const PantallaEspera() : holder;
  }

  Widget _pantallaTarjetas() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF192153),
        centerTitle: true,
        title: const Text(
          "Mis Tarjetas",
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
                  Navigator.of(context).pushNamed("/pantallaAgregarTarjeta", arguments: "/PantallaPago");
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
                        "Agregar nueva tarjeta",
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
                  itemCount: tarjetas.length,
                  itemBuilder: (context, position) {
                    return tarjetas.isEmpty
                        ? Container()
                        : _widgetTarjeta(tarjetas[position]);
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
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Pagar",
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

  Widget _widgetTarjeta(Tarjeta _tarjeta) {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
        height: 100,
        child: TextButton(
          onPressed: () {
            //metodo para la selección
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Radio(
                  value: _tarjeta.id,
                  groupValue: Constantes.control,
                  onChanged: (T) {
                    setState(() {
                      Constantes.control = _tarjeta.id;
                      holder = _pantallaTarjetas();
                    });
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    _tarjeta.propietario,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Visa " + _tarjeta.numero,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ));
  }

  _getListaTarjetas() async {
    print("Intentando obtener lista de tarjetas");
    TarjetaCRUD tarjetaCrud = TarjetaCRUD();
    await tarjetaCrud.getTarjetas(Constantes.miID).then((val) async {
      print("Intentando obtener datos");
      if (val != null) {
        print("Hay Datos");
        QuerySnapshot querySnapshot = val;
        if (querySnapshot.size != 0) {
          print("Hay tarjetas");
          Tarjeta tarjeta;
          for (int i = 0; i < querySnapshot.docs.length; i++) {
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
        } else {
          print("No hay tarjetas");
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
          await _getListaTarjetas().then((val){
            setState(() {
              isLoading = false;
              holder = _pantallaTarjetas();
            });
          });
        } else {
          print("No hay carritos");
          setState(() {
            isLoading = false;
            holder = _pantallaTarjetas();
          });
        }
      } else {
        print("No se recibieron datos");
        setState(() {
          isLoading = false;
          holder = _pantallaTarjetas();
        });
      }
      setState(() {
        isLoading = false;
        holder = _pantallaTarjetas();
      });
    });
    setState(() {
      isLoading = false;
      holder = _pantallaTarjetas();
    });
  }
}
