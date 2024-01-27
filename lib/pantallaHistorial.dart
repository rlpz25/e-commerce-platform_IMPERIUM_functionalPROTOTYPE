import 'package:flutter/material.dart';
import 'package:imperium/pantallaEspera.dart';
import 'clases/carrito.dart';
import 'clases/tarjeta.dart';

class PantallaHistorial extends StatefulWidget {
  const PantallaHistorial({Key? key}) : super(key: key);
  @override
  _PantallaHistorialState createState() => _PantallaHistorialState();
}

class _PantallaHistorialState extends State<PantallaHistorial> {
  @override
  void initState() {
    
    super.initState();
  }

  late Widget holder = Container();
  bool isLoading = true;
  double total = 0;
  List<Carrito> compras = [];

  @override
  Widget build(BuildContext context) {
    return isLoading ? const PantallaEspera() : holder;
  }

  Widget _pantallaHistorial() {
    return Container(
      width: double.infinity,
      child: ListView.builder(
        itemCount: compras.length,
          itemBuilder: (context, position){
        return compras.isEmpty ? Container(): _widgetCompra(compras[position]);
      })
    );
  }

  Widget _widgetCompra(Carrito _carrito) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.only(top: 15, bottom: 10, left: 25, right: 25),
      child: Column(
        children: [
          Container(),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }

}
