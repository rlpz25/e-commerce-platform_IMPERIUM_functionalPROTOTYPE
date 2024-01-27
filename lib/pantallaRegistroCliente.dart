import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imperium/clases/cliente.dart';
import 'package:imperium/crud/clientecrud.dart';
import 'package:imperium/crudtolocal/clientecrudlocal.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/services/auth.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/services/sharedprefs.dart';
import 'package:imperium/widgets/widgets.dart';

class PantallaRegistroCliente extends StatefulWidget {
  const PantallaRegistroCliente({Key? key}) : super(key: key);

  @override
  _PantallaRegistroClienteState createState() =>
      _PantallaRegistroClienteState();
}

class _PantallaRegistroClienteState extends State<PantallaRegistroCliente> {

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoTEC = TextEditingController();
  final TextEditingController _confCorreoTEC = TextEditingController();
  final TextEditingController _contrasenaTEC = TextEditingController();
  final TextEditingController _confContrasenaTEC = TextEditingController();
  final TextEditingController _idTEC = TextEditingController();
  final TextEditingController _nombreTEC = TextEditingController();
  final TextEditingController _apellidoTEC = TextEditingController();
  final TextEditingController _telefonoTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading ? PantallaEspera() : Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF192153),
          toolbarHeight: 80,
          title: const Text(
            "Registro",
            style: TextStyle(fontSize: 25, letterSpacing: 2),
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
                    _id(),
                    _nombre(),
                    _apellido(),
                    _correo(),
                    _confircorreo(),
                    _telefono(),
                    _contrasena(),
                    _confirmcontra(),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 70, right: 70, top: 15, bottom: 15),
                        backgroundColor: const Color(0xFF192153),
                      ),
                      onPressed: () {
                        _registrarUsuario();
                      },
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/pantallaInicioSesion');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 70, right: 70, top: 30, bottom: 15),
                      ),
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  _correo() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu correo";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        controller: _correoTEC,
        decoration:
            const InputDecoration(icon: Icon(Icons.email), hintText: "Correo"),
      ),
    );
  }

  _contrasena() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        validator: (val) {
          if (val == "") {
            return "Escribe tu contraseña";
          } else {
            if (_contrasenaTEC.text.length < 6) {
              return "La contraseña debe tener al menos 6 caracteres";
            }
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _contrasenaTEC,
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.vpn_key_rounded), hintText: "Contraseña"),
      ),
    );
  }

  _confircorreo() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        validator: (val) {
          if (val == "") {
            return "Confirma tu correo";
          } else {
            if (val != _correoTEC.text) {
              return "Los campos son diferentes";
            }
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        controller: _confCorreoTEC,
        decoration: const InputDecoration(
            icon: Icon(Icons.drafts), hintText: "Confirmar correo"),
      ),
    );
  }

  _confirmcontra() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        validator: (val) {
          if (val == "") {
            return "Confirma tu contraseña";
          } else {
            if (val != _contrasenaTEC.text) {
              return "Los campos son diferentes";
            }
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _confContrasenaTEC,
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.vpn_key_rounded),
          hintText: "Confirmar contraseña",
        ),
      ),
    );
  }

  _id() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu ID unico";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _idTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.person_pin_circle),
          hintText: "ID Unico",
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

  _apellido() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (val) {
          return val != "" ? null : "Ingresa tu Apellido";
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _apellidoTEC,
        decoration: const InputDecoration(
          icon: Icon(Icons.group),
          hintText: "Apellido",
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

  _registrarUsuario() {
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
    if (kDebugMode) {
      print("Validando si existe el cliente");
    }
    ClienteCRUD clienteCRUD = ClienteCRUD();
    clienteCRUD.getClienteConID(_idTEC.text).then((val) {
      QuerySnapshot idQuery = val;
      if (idQuery.size == 0) {
        if (kDebugMode) {
          print("El id unico no existe");
        }
        clienteCRUD.getClienteConCorreo(_confCorreoTEC.text).then((val2) {
          QuerySnapshot correoQuery = val2;
          if (correoQuery.size == 0) {
            if (kDebugMode) {
              print("El correo no existe");
            }
            AuthMethods authMethods = AuthMethods();
            authMethods.createUserWithEmailAndPassword(
              context, _confCorreoTEC.text, _confContrasenaTEC.text)
                .then((value){
                  if (kDebugMode) {
                    print("Usuario creado");
                  }
              _guardarDatosCliente();
                  setState(() {
                    isLoading = false;
                  });
            });
            if (kDebugMode) {
              print("Finalizado sin confirmar guardado");
            }
          } else {
            notificacion(context, "Ya existe un usuario con este correo");
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        notificacion(context, "Ya existe un usuario con este ID");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  _guardarDatosCliente() {
    if (kDebugMode) {
      print("Guardando datos del cliente");
    }
    Cliente _cliente = Cliente.full(_idTEC.text, _nombreTEC.text, _apellidoTEC.text, _confCorreoTEC.text, _telefonoTEC.text);
    try {
      ClientelocalCRUD clientelocalCRUD = ClientelocalCRUD();
      clientelocalCRUD.agregarModificarCliente(_cliente);
      if (kDebugMode) {
        print(_cliente.id);
      }
      Constantes.miID = _cliente.id;
      Constantes.miCorreo = _cliente.correo;
      Constantes.miNombre = _cliente.nombre;
      if (kDebugMode) {
        print("Datos de las Constantes:");
        print(Constantes.miNombre);
        print(Constantes.miID);
        print(Constantes.miCorreo);
      }
      SharedPrefs.saveUserSP(true);
      SharedPrefs.saveIdSP(Constantes.miID);
      SharedPrefs.saveCorreo(Constantes.miCorreo);
      SharedPrefs.saveNombre(Constantes.miNombre);
      if (kDebugMode) {
        print("Datos del Shared Prefferences:");
        print(SharedPrefs.getIDSP() as String);
        print(SharedPrefs.getNombreSP() as String);
        print(SharedPrefs.getCorreoSP() as String);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
