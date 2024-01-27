import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/auth.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/services/sharedprefs.dart';
import 'package:imperium/widgets/widgets.dart';

import 'clases/cliente.dart';
import 'crud/clientecrud.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({Key? key}) : super(key: key);

  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoTEC = TextEditingController();
  final TextEditingController _contrasenaTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const PantallaEspera()
        : Scaffold(
            appBar: AppBar(
                toolbarHeight: 80,
                backgroundColor: const Color(0xFF192153),
                title: const Text(
                  "Iniciar sesión",
                  style: TextStyle(fontSize: 25, letterSpacing: 3),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.home,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/pantallaPrincipalUsuario');
                  },
                )),
            body: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 300,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _correo(),
                          _contrasena(),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  left: 70, right: 70, top: 15, bottom: 15),
                              backgroundColor: const Color(0xFF192153),
                            ),
                            onPressed: () {
                              _iniciarSesion();
                            },
                            child: const Text(
                              "Iniciar sesión",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/pantallaRegistroCliente');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  left: 70, right: 70, top: 30, bottom: 15),
                            ),
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                color: Colors.indigoAccent,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                letterSpacing: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ])),
            ));
  }

  _correo() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(top: 50),
      child: TextFormField(
        controller: _correoTEC,
        validator: (val) {
          if (val == "") {
            return "Ingresa tu correo";
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        decoration:
            const InputDecoration(icon: Icon(Icons.email), hintText: "Correo"),
      ),
    );
  }

  _contrasena() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(top: 10, bottom: 50),
      child: TextFormField(
        controller: _contrasenaTEC,
        validator: (val) {
          return val != "" ? null : "Ingresa tu contraseña";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.vpn_key_rounded), hintText: "Contraseña"),
      ),
    );
  }

  _iniciarSesion() {
    Constantes.pantallaEstado = 0;
    if (_formKey.currentState?.validate() != null) {
      if (_formKey.currentState?.validate() == true) {
        setState(() {
          isLoading = true;
        });
        _validarIDCorreo();
      }
    }
  }

  _validarIDCorreo() {
    print("Validando si existe el correo");
    ClienteCRUD clienteCRUD = ClienteCRUD();
    try {
      clienteCRUD.getClienteConCorreo(_correoTEC.text).then((val2) {
        QuerySnapshot correoQuery = val2;
        if (correoQuery.size != 0) {
          print("Existe el correo");
          AuthMethods authMethods = AuthMethods();
          authMethods
              .signInWithEmailAndPassword(
                  context, _correoTEC.text, _contrasenaTEC.text)
              .then((value) {
            _guardarDatosCliente();
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print("No existe el correo");
          notificacion(context, "No existe una cuenta con este correo");
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  _guardarDatosCliente() {
    print("Guardando datos del cliente");
    ClienteCRUD clienteCRUD = ClienteCRUD();
    clienteCRUD.getClienteConCorreo(_correoTEC.text).then((val) {
      QuerySnapshot querySnapshot = val;
      Cliente cliente = Cliente.full(
          querySnapshot.docs[0].id,
          querySnapshot.docs[0].get("nombre"),
          querySnapshot.docs[0].get("apellido"),
          querySnapshot.docs[0].get("correo"),
          querySnapshot.docs[0].get("telefono"));
      print("El cliente es");
      print(cliente.id);
      print(cliente.nombre);
      print(cliente.apellido);
      print(cliente.correo);
      print(cliente.telefono);
      Constantes.miID = cliente.id;
      Constantes.miCorreo = cliente.correo;
      Constantes.miNombre = cliente.nombre;
      print("Datos de las Constantes");
      print(Constantes.miNombre);
      print(Constantes.miID);
      print(Constantes.miCorreo);
      SharedPrefs.saveUserSP(true);
      SharedPrefs.saveIdSP(Constantes.miID);
      SharedPrefs.saveCorreo(Constantes.miCorreo);
      SharedPrefs.saveNombre(Constantes.miNombre);
      print("Datos del Shared Prefs");
      print(SharedPrefs.getIDSP());
      print(SharedPrefs.getNombreSP());
      print(SharedPrefs.getCorreoSP());
      setState(() {
        isLoading = false;
      });
    });
  }
}
