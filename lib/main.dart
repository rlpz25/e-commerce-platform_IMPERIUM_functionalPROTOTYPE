import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imperium/pantallaAgregarDireccion.dart';
import 'package:imperium/pantallaAgregarTarjeta.dart';
import 'package:imperium/pantallaHistorial.dart';
import 'package:imperium/pantallaTarjetasEnvio.dart';
import 'package:imperium/pantallaPrincipalCliente.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/services/sharedprefs.dart';
import 'package:imperium/pantallaEspera.dart';
import 'pantallaDireccionEnvio.dart';
import 'pantallaCarrito.dart';
import 'pantallaInicioSesion.dart';
import 'pantallaRegistroCliente.dart';
import 'pantallaPrincipalUsuario.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLogged = false;
  bool isLoading = true;

  @override
  void initState() {
    if (kDebugMode) {
      print("initState");
    }
    _getLoggedInState();
    super.initState();
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("Dispose");
    }
  }

  @override
  void builder() {
    if (kDebugMode) {
      print("Builder");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Algo salio mal',
            home: Scaffold(
              body: Center(
                child: Text(
                  'Algo Salio mal :(',
                  style: TextStyle(
                      fontSize: 30
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Imperium',
            theme: ThemeData(
              primaryColor: Colors.indigo[900],
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: Colors.white,
                  size: 50,
                ),
              ),
              hoverColor: Colors.red

            ),
            home: isUserLogged ? const PantallaPrincipalCliente(title: "IMPERIUM") : const PantallaPrincipalUsuario(title: "IMPERIUM"),
            routes: {
              "/pantallaPrincipalUsuario":(BuildContext context)=> const PantallaPrincipalUsuario(title: 'IMPERIUM',),
              "/pantallaInicioSesion":(BuildContext context)=> const PantallaInicioSesion(),
              "/pantallaRegistroCliente":(BuildContext context)=> const PantallaRegistroCliente(),
              "/pantallaPrincipalCliente":(BuildContext context)=> const PantallaPrincipalCliente(title: "IMPERIUM"),
              "/Carrito":(BuildContext context)=> const PantallaCarrito(),
              "/Direc":(BuildContext context)=> const PantallaDireccionEnvio(),
              "/PantallaPago":(BuildContext context)=> PantallaTarjetasEnvio(),
              "/pantallaAgregarDireccion":(BuildContext context)=> PantallaAgregarDireccion(),
              "/pantallaAgregarTarjeta":(BuildContext context)=> PantallaAgregarTarjeta(),
              "/pantallaHistorial":(BuildContext context)=> PantallaHistorial(),
            },
          );
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Algo salio mal',
          home: PantallaEspera(),
        );
      },
    );
  }

  _getUserInfo(){
    if (kDebugMode) {
      print("Intentando obtener datos..");
    }
    SharedPrefs.getNombreSP().then((value){
      //print(value.runtimeType);
      if(value != null){
        if (kDebugMode) {
          print("Nombre obtenido: " + value);
        }
        Constantes.miNombre = value;
      } else {
        if (kDebugMode) {
          print("Sin nombre");
        }
      }
    });
    SharedPrefs.getIDSP().then((value){
      if(value != null){
        if (kDebugMode) {
          print("ID Unico obtenido: " + value);
        }
        Constantes.miID = value;
      } else {
        if (kDebugMode) {
          print("Sin id");
        }
      }
    });
    SharedPrefs.getCorreoSP().then((value){
      if(value != null){
        if (kDebugMode) {
          print("Correo obtenido: " + value);
        }
        Constantes.miCorreo = value as String;
      } else {
        if (kDebugMode) {
          print("Sin correo");
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  _getLoggedInState() async {
    if (kDebugMode) {
      print("Consultando si existe una sesión activa");
    }
    await SharedPrefs.getUserSP().then((value){
      if (kDebugMode) {
        print("Accediendo al archivo");
      }
      if(value != null){
        if (kDebugMode) {
          print("Hay información");
        }
        isUserLogged = value;
        if (kDebugMode) {
          isUserLogged ? print("Hay una sesión activa") : print("No hay una sesión activa");
        }
        isUserLogged ?
        _getUserInfo() :
        null;
      } else {
        if (kDebugMode) {
          print("No hay información");
        }
        isUserLogged = false;
        setState(() {
          isLoading = false;
        });
      }
    });
  }

}




