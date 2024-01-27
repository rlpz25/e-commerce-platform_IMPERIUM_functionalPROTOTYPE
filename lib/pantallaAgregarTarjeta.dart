import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/constants.dart';
import 'clases/tarjeta.dart';
import 'crudtolocal/tarjetacrudlocal.dart';

class PantallaAgregarTarjeta extends StatefulWidget {
  const PantallaAgregarTarjeta({Key? key}) : super(key: key);

  @override
  _PantallaAgregarTarjetaState createState() => _PantallaAgregarTarjetaState();
}

class _PantallaAgregarTarjetaState extends State<PantallaAgregarTarjeta> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idTEC = TextEditingController();
  final TextEditingController _propietarioTEC = TextEditingController();
  final TextEditingController _numeroTEC = TextEditingController();
  final TextEditingController _mesTEC = TextEditingController();
  final TextEditingController _anyoTEC = TextEditingController();
  final TextEditingController _cvcTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pantallaAnterior = ModalRoute.of(context)!.settings.arguments as String;
    return isLoading
        ? PantallaEspera()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF192153),
              toolbarHeight: 80,
              title: const Text(
                "Registrar tarjeta",
                style: TextStyle(fontSize: 25, letterSpacing: 2),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _propietario(),
                              _numero(),
                              _mes(),
                              _anyo(),
                              _ccv(),
                              SizedBox(
                                height: 60,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 70, right: 70, top: 15, bottom: 15),
                                  backgroundColor: const Color(0xFF192153),
                                ),
                                onPressed: () {
                                  guardarDatosTarjeta().then((val){
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(context, pantallaAnterior);
                                  });
                                },
                                child: const Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          ))
                    ]),
              ),
            ),
          );
  }

  _mes() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Mes de expiración";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _mesTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.access_time_outlined),
          hintText: "Mes",
        ),
      ),
    );
  }

  _propietario() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu Nombre";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _propietarioTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: "Nombre",
        ),
      ),
    );
  }

  _anyo() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Año en que vence la tarjeta";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _anyoTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          hintText: "Año",
        ),
      ),
    );
  }

  _ccv() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "CCV (3 digitos al reverso de tu tarjeta)";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        controller: _cvcTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.credit_card),
          hintText: "CCV",
        ),
      ),
    );
  }

  _numero() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu numero de tarjeta";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        controller: _numeroTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.art_track),
          hintText: "Numero de tarjeta",
        ),
      ),
    );
  }

  guardarDatosTarjeta() async {
    if (kDebugMode) {
      print("Guardando datos del cliente");
    }

    Tarjeta _tarjeta = Tarjeta.full(
      0,
      _propietarioTEC.text,
      _numeroTEC.text,
      _mesTEC.text,
      _anyoTEC.text,
      _cvcTEC.text,
    );
    TarjetaLocalCRUD tarjetalocalCRUD = TarjetaLocalCRUD();
    await tarjetalocalCRUD.agregarTarjeta(Constantes.miID, _tarjeta);
  }
}
