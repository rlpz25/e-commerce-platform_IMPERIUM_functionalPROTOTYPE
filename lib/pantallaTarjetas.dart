import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/crud/tarjetacrud.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'clases/tarjeta.dart';

class PantallaTarjetas extends StatefulWidget {
  const PantallaTarjetas({Key? key}) : super(key: key);
  @override
  _PantallaTarjetasState createState() => _PantallaTarjetasState();
}

class _PantallaTarjetasState extends State<PantallaTarjetas> {
  @override
  void initState() {
    _getListaTarjetas();
    super.initState();
  }

  late Widget holder = Container();
  bool isLoading = true;
  double total = 0;
  List<Tarjeta> tarjetas = [];

  @override
  Widget build(BuildContext context) {
    return isLoading ? const PantallaEspera() : holder;
  }

  Widget _pantallaTarjetas() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: 320,
            height: 80,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/pantallaAgregarTarjeta", arguments: "/pantallaPrincipalCliente");
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
                  const SizedBox(
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
          setState(() {
            isLoading = false;
            holder = _pantallaTarjetas();
          });
        } else {
          print("No hay tarjetas");
          setState(() {
            isLoading = false;
            holder = _pantallaTarjetas();
          });
        }
      } else {
        print("No hay datos");
        setState(() {
          isLoading = false;
          holder = _pantallaTarjetas();
        });
      }
    });
  }
}
