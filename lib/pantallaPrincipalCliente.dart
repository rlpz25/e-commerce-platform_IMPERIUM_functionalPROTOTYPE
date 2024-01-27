import 'package:flutter/material.dart';
import 'package:imperium/pantallaCarrito.dart';
import 'package:imperium/pantallaHistorial.dart';
import 'package:imperium/pantallaProductos.dart';
import 'package:imperium/services/auth.dart';
import 'package:imperium/services/constants.dart';
import 'package:imperium/services/sharedprefs.dart';
import 'clases/producto.dart';
import 'pantallaDirecciones.dart';
import 'pantallaTarjetas.dart';

class PantallaPrincipalCliente extends StatefulWidget {
  const PantallaPrincipalCliente({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<PantallaPrincipalCliente> createState() =>
      _PantallaPrincipalClienteState();
}

class _PantallaPrincipalClienteState extends State<PantallaPrincipalCliente> {
  List<Producto> productos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF192153),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/imperium-bd.appspot.com/o/imperium_logo.png?alt=media&token=81f93ece-a0eb-4d22-97d7-56de6d2eff51",
                        height: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "IMPERIUM",
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 5, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Inicio",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              onTap: () {
                setState(() {
                  Constantes.pantallaEstado = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text(
                "Mi carrito",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              onTap: () {
                setState(() {
                  Constantes.pantallaEstado = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text(
                "Mis tarjetas",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              onTap: () {
                setState(() {
                  Constantes.pantallaEstado = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt),
              title: const Text(
                "Mis direcciones",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              onTap: () {
                setState(() {
                  Constantes.pantallaEstado = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text(
                "Mis compras",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              onTap: () {
                setState(() {
                  Constantes.pantallaEstado = 4;
                });
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.red,
              ),
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(fontSize: 20, letterSpacing: 2),
              ),
              onTap: () {
                _cerrarSesion();
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed("/pantallaPrincipalUsuario");
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF192153),
        centerTitle: true,
        title: Constantes.pantallaEstado == 0
            ? const Text(
                "IMPERIUM",
                style: TextStyle(
                    fontSize: 30, color: Colors.white, letterSpacing: 9),
              )
            : Constantes.pantallaEstado == 1
                ? const Text(
                    "Mi Carrito",
                    style: TextStyle(
                        fontSize: 30, color: Colors.white, letterSpacing: 3),
                  )
                : Constantes.pantallaEstado == 2
                    ? const Text(
                        "Mis Tarjetas",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            letterSpacing: 1),
                      )
                    : Constantes.pantallaEstado == 3
                        ? const Text(
                            "Mis direcciones",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                letterSpacing: 1),
                          )
                        : const Text("Historial de compras",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                letterSpacing: 1)),
        actions: Constantes.pantallaEstado == 0
            ? <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 40,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 30),
                  onPressed: () {
                    setState(() {
                      Constantes.pantallaEstado = 1;
                    });
                  },
                ),
              ]
            : null,
      ),
      //inicia lista de productos
      body: Constantes.pantallaEstado == 0
          ? PantallaProductos()
          : Constantes.pantallaEstado == 1
              ? const PantallaCarrito()
              : Constantes.pantallaEstado == 2
                  ? const PantallaTarjetas()
                  : Constantes.pantallaEstado == 3
                      ? const Direcciones()
                      : const PantallaHistorial(),
    );
  }

  _cerrarSesion() {
    AuthMethods authMethods = AuthMethods();
    authMethods.signOut();
    SharedPrefs.limpiarPreferencias();
    SharedPrefs.saveUserSP(false);
    Constantes.miCorreo = "";
    Constantes.miID = "";
    Constantes.miNombre = "";
  }
}
