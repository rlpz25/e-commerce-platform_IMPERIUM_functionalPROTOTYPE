import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imperium/clases/producto.dart';
import 'package:imperium/pantallaEspera.dart';
import 'package:imperium/widgets/widgethome.dart';

import 'crud/productocrud.dart';

class PantallaProductos extends StatefulWidget {
  PantallaProductos({Key? key}) : super(key: key);

  @override
  _PantallaProductosState createState() => _PantallaProductosState();
}

class _PantallaProductosState extends State<PantallaProductos> {

  @override
  void initState() {
    _getListaProducto();
    super.initState();
  }

  bool _isLoading = true;
  List<Producto> productos = [];

  @override
  Widget build(BuildContext context) {

    if(_isLoading){
      return const PantallaEspera();
    } else {
      return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, position) {
            return productos.isEmpty
                ? Container()
                : Contenedor(productos[position]);
          });
    }

  }

  _getListaProducto() async {
    ProductoCRUD productoCRUD = ProductoCRUD();
    await productoCRUD.getProductos().then((val) {
      QuerySnapshot querySnapshot = val;
      Producto producto;
      if (val != null) {
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
          productos.add(producto);
        }
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

}
