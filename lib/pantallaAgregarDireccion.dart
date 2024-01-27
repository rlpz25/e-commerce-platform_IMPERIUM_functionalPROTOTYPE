import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/auth.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/services/sharedprefs.dart';
import 'package:imperium/widgets/widgets.dart';
import 'clases/direccion.dart';
import 'crud/direccioncrud.dart';
import 'crudtolocal/direccioncrudlocal.dart';

class PantallaAgregarDireccion extends StatefulWidget {
  const PantallaAgregarDireccion({Key? key}) : super(key: key);

  @override
  _PantallaAgregarDireccionState createState() =>
      _PantallaAgregarDireccionState();
}

class _PantallaAgregarDireccionState extends State<PantallaAgregarDireccion> {

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idTEC = TextEditingController();
  final TextEditingController _nombreTEC = TextEditingController();
  final TextEditingController _paisTEC = TextEditingController();
  final TextEditingController _telefonoTEC = TextEditingController();
  final TextEditingController _estadoTEC = TextEditingController();
  final TextEditingController _ciudadTEC = TextEditingController();
  final TextEditingController _coloniaTEC = TextEditingController();
  final TextEditingController _calleTEC = TextEditingController();
  final TextEditingController _no_interiorTEC = TextEditingController();
  final TextEditingController _codpostTEC = TextEditingController();

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
                "Registrar direccion",
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
                              _nombre(),
                              _telefono(),
                              _pais(),
                              _estado(),
                              _ciudad(),
                              _colonia(),
                              _calle(),
                              _no_interior(),
                              _codpost(),
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
                                  guardarDatosDireccion().then((val){
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacementNamed(pantallaAnterior);
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

  _ciudad() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ciudad al que perteneces";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _ciudadTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.location_city),
          hintText: "Ciudad",
        ),
      ),
    );
  }

  _estado() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Estado al que perteneces";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _estadoTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.account_balance_outlined),
          hintText: "Estado",
        ),
      ),
    );
  }

  _nombre() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu Nombre";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _nombreTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: "Nombre",
        ),
      ),
    );
  }

  _pais() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Pais al que perteneces";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _paisTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.landscape),
          hintText: "País",
        ),
      ),
    );
  }

  _colonia() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Colonia a la que perteneces";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _coloniaTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.home_work),
          hintText: "Colonia",
        ),
      ),
    );
  }

  _no_interior() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresar numero de casa";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        controller: _no_interiorTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.home),
          hintText: "No. interior",
        ),
      ),
    );
  }

  _codpost() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresar código postal";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        controller: _codpostTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.markunread_mailbox),
          hintText: "Código Postal",
        ),
      ),
    );
  }

  _calle() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresar Calle";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _calleTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.streetview),
          hintText: "Calle",
        ),
      ),
    );
  }

  _telefono() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu telefono";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        controller: _telefonoTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.phone),
          hintText: "Telefono",
        ),
      ),
    );
  }

  guardarDatosDireccion() async {
    if (kDebugMode) {
      print("Guardando datos del cliente");
    }

    Direccion _direccion = Direccion.full(
        0,
        _nombreTEC.text,
        _telefonoTEC.text,
        _paisTEC.text,
        _estadoTEC.text,
        _ciudadTEC.text,
        _coloniaTEC.text,
        _calleTEC.text,
        _no_interiorTEC.text,
        _codpostTEC.text);
    DireccionLocalCRUD direccionlocalCRUD = DireccionLocalCRUD();
    await direccionlocalCRUD.agregarDireccion(Constantes.miID, _direccion);
  }
}
