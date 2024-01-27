import 'package:imperium/crudtolocal/carritocrudlocal.dart';
import 'package:imperium/services/constants.dart';
import '../clases/producto.dart';
import 'package:flutter/material.dart';

class Contenedor extends StatefulWidget {
  Producto producto;
  Contenedor(this.producto) {}
  @override
  _ContenedorState createState() => _ContenedorState(producto);
}

class _ContenedorState extends State<Contenedor> {
  Producto _producto;
  bool isLoading = false;
  int cont = 1;
  _ContenedorState(this._producto) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.network(
                _producto.imagen,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Text(
                          _producto.nombre,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 120,
                        child: Text(
                          "\$ " + _producto.precio.toString() + " MXN",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          if (cont > 1) {
                            setState(() {
                              cont--;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(right: 1)),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      cont.toString().padLeft(
                            2,
                            "0",
                          ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: OutlineButton(
                        padding: EdgeInsets.only(right: 3),
                        onPressed: () {
                          if (cont < _producto.stock) {
                            setState(() {
                              cont++;
                            });
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF192153)),
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: IconButton(
                      onPressed: () {
                        _formularioProducto(context, _producto, cont);
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }

  Future<void> _formularioProducto(context, Producto producto, int cantidad) async {

    double _subtotal = cantidad * producto.precio, _precio = _producto.precio;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Resumen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  GestureDetector(
                    child: const Icon(
                        Icons.close,
                        color: Colors.red
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                height: 400,
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Image(
                          image: NetworkImage(producto.imagen),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        producto.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text("Talla: " + _producto.talla),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text("Precio: " + _precio.toStringAsFixed(2)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text("Cantidad: $cantidad"),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text("Precio: " + _precio.toStringAsFixed(2)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Subtotal: " + _subtotal.toStringAsFixed(2)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async{
                            Producto auxiliar = Producto.full(producto.id, producto.nombre, producto.descripcion, producto.imagen, cont, producto.talla, producto.precio);
                            CarritoLocalCRUD carritoLocalCRUD = CarritoLocalCRUD();
                            await carritoLocalCRUD.agregarModificarCarritoProducto(Constantes.miID, auxiliar).then((val){
                              Navigator.pop(context);
                            });
                          },
                          label: const Text("Agregar"),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () async {
                            setState(() {
                              Constantes.pantallaEstado = 1;
                            });
                            Producto auxiliar = Producto.full(producto.id, producto.nombre, producto.descripcion, producto.imagen, cont, producto.talla, producto.precio);
                            CarritoLocalCRUD carritoLocalCRUD = CarritoLocalCRUD();
                            await carritoLocalCRUD.agregarModificarCarritoProducto(Constantes.miID, auxiliar).then((val){
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacementNamed("/pantallaPrincipalCliente");
                            });
                          },
                          label: const Text("Ir al carrito"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
