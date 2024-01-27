import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/clases/producto.dart';
import 'package:imperium/crud/productocrud.dart';
import 'widgets/widgets.dart';
import 'pantallaEspera.dart';

class PantallaPrincipalUsuario extends StatefulWidget {
  const PantallaPrincipalUsuario({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PantallaPrincipalUsuario> createState() => _PantallaPrincipalUsuarioState();
}

class _PantallaPrincipalUsuarioState extends State<PantallaPrincipalUsuario> {

  @override
  void initState() {
    _getListaProducto();
    super.initState();
  }

  bool _isLoading = true;

  List<Producto> _productos = [];

  @override
  Widget build(BuildContext context) {

    return _isLoading ? const PantallaEspera() : Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color(0xFF192153),
          centerTitle: true,
          title: const Text(
            "IMPERIUM",
            style: TextStyle(fontSize: 30, color: Colors.white, letterSpacing: 9),
          ),

          leading: IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 40, color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed("/pantallaInicioSesion");
            },
          )
      ),
      body: ListView.builder(
          itemCount: _productos.length,
          itemBuilder: (context, position){
            return _productos.isEmpty ? Container() : Contenedor(_productos[position]);
          }
      ),
    );
  }

  _getListaProducto() async {
    ProductoCRUD productoCRUD = ProductoCRUD();
    await productoCRUD.getProductos().then((val) {
      QuerySnapshot querySnapshot = val;
      Producto producto;
      if(val != null) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          producto = Producto.full(
            int.parse(querySnapshot.docs[i].id),
            querySnapshot.docs[i].get("nombre"),
            querySnapshot.docs[i].get("descripcion"),
            querySnapshot.docs[i].get("imagen"),
            querySnapshot.docs[i].get("stock"),
            querySnapshot.docs[i].get("talla"),
            querySnapshot.docs[i].get("precio"),
          );
          _productos.add(producto);
        }
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

}