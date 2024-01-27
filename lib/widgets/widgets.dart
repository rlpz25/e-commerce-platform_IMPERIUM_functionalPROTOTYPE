import '../clases/producto.dart';
import 'package:flutter/material.dart';

class Contenedor extends StatelessWidget {
  Producto producto;

  Contenedor(this.producto, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          producto.imagen != "" ? Container(
            child: Image.network(
              producto.imagen,
              width: 380,
              fit: BoxFit.fitWidth,
            ),
          ) : Container(),
          producto.nombre != "" ?Container(
            margin: const EdgeInsets.only(top: 14),
            alignment: Alignment.bottomLeft,
            child: Text(
              producto.nombre,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(),
          producto.precio >= 0 ? Container(
            padding: const EdgeInsets.only(top: 6),
            alignment: Alignment.bottomLeft,
            child: Text(
              "\$ " + producto.precio.toString() + " MXN",
              style: const TextStyle(color: Colors.grey),
            ),
          ) : Container(),
        ],
      ),
    );
  }

}

TextButtonMyStyle(){
  return ButtonStyle(
    overlayColor: MaterialStateProperty.all(Colors.indigo[50]),
  );
}

Future<void> notificacion(context, String mensaje) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            mensaje,
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);},
              label: const Text("Cerrar"),
            ),
          ],
        );
      });
}
