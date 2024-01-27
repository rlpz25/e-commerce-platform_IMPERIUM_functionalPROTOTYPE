import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/clases/carrito.dart';
import 'package:imperium/clases/producto.dart';
import 'package:imperium/crud/carritocrud.dart';

class CarritoLocalCRUD {
  CarritoCRUD carritoCRUD = CarritoCRUD();

  List<Carrito> listarCarritos(String idCliente) {
    List<Carrito> carritos = [];
    carritoCRUD.getCarritos(idCliente).then((val) {
      QuerySnapshot querySnapshot = val;
      Carrito carrito;

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        carrito = Carrito.full(
          int.parse(querySnapshot.docs[i].id),
          querySnapshot.docs[i].get("total"),
          querySnapshot.docs[i].get("finalizado"),
          querySnapshot.docs[i].get("ultimo"),
        );
        carritos.add(carrito);
        print("Carrito creado");
      }
    });
    print("Devolviendo datos...");
    return carritos;
  }

  listarCarritoProductos(String idCliente) async {
    String idCarrito;
    List<Producto> productos = [];
    await carritoCRUD.getUltimoCarrito(idCliente).then((val) async {
      QuerySnapshot querySnapshot = val;
      if (querySnapshot.size > 0) {
        idCarrito = querySnapshot.docs[0].id.toString();
        await carritoCRUD.getCarritoProductos(idCliente, idCarrito).then((val) {
          querySnapshot = val;
          Producto producto;
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            producto = Producto.full(
              int.parse(querySnapshot.docs[i].id),
              querySnapshot.docs[i].get("nombre"),
              "",
              querySnapshot.docs[i].get("imagen"),
              querySnapshot.docs[i].get("stock"),
              querySnapshot.docs[i].get("talla"),
              querySnapshot.docs[i].get("precio"),
            );
            productos.add(producto);
            print("Producto creado");
          }
        });
      }
    });
    print("Devolviendo datos...");
    return productos;
  }

  obtenerCarrito(String idCliente, String idCarrito){
    late Carrito carrito;
    carritoCRUD.getCarritoConID(idCliente, idCarrito).then((val) {
      QuerySnapshot querySnapshot = val;
      if (querySnapshot.size > 0) {
        carrito = Carrito.full(
          int.parse(querySnapshot.docs[0].id),
          querySnapshot.docs[0].get("total"),
          querySnapshot.docs[0].get("finalizado"),
          querySnapshot.docs[0].get("ultimo"),
        );
      } else {
        carrito = Carrito.full(0, 0.0, false, false);
      }
    });
    return carrito;
  }

  obtenerUltimoCarrito(String idCliente) {
    late Carrito carrito;
    carritoCRUD.getUltimoCarrito(idCliente).then((val) {
      QuerySnapshot querySnapshot = val;
      if (querySnapshot.size > 0) {
        carrito = Carrito.full(
          int.parse(querySnapshot.docs[0].id),
          querySnapshot.docs[0].get("total"),
          querySnapshot.docs[0].get("finalizado"),
          querySnapshot.docs[0].get("ultimo"),
        );
      } else {
        carrito = Carrito.full(0, 0.0, false, false);
      }
    });
    return carrito;
  }

  List<Carrito> obtenerCarritosPendientes(String idCliente) {
    List<Carrito> carritos = [];
    carritoCRUD.getCarritosPendientes(idCliente).then((val) {
      QuerySnapshot querySnapshot = val;
      Carrito carrito;

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        carrito = Carrito.full(
          int.parse(querySnapshot.docs[i].id),
          querySnapshot.docs[i].get("total"),
          querySnapshot.docs[i].get("finalizado"),
          querySnapshot.docs[i].get("ultimo"),
        );
        carritos.add(carrito);
        print("Carrito creado");
      }
    });
    print("Devolviendo datos...");
    return carritos;
  }

  agregarModificarCarrito(String idCliente, List<Producto> productos) async {
    int idCarrito = 1;
    double total = 0;
    for (int i = 0; i <= productos.length; i++) {
      total = total + productos[i].precio;
    }
    Map<String, dynamic> carritoMap = {
      "id": idCarrito,
      "total": total,
      "finalizado": false,
      "ultimo": true,
    };
    CarritoCRUD carritoCRUD = CarritoCRUD();
    await carritoCRUD.getUltimoCarrito(idCliente).then((val) async {
      if (val != null) {
        QuerySnapshot querySnapshot = val;
        if (val.size != 0) {
          idCarrito = querySnapshot.docs[0].get("id");
          carritoMap = {
            "id": querySnapshot.docs[0].get("id"),
            "total": querySnapshot.docs[0].get("total"),
            "finalizado": querySnapshot.docs[0].get("finalizado"),
            "ultimo": querySnapshot.docs[0].get("ultimo"),
          };
        } else {
          print("No hay carritos");
        }
      } else {
        print("No hay datos");
      }
      await carritoCRUD
          .agregarModificarCarrito(idCliente, idCarrito.toString(), carritoMap)
          .then((val) async {
        for (int i = 0; i < productos.length; i++) {
          Map<String, dynamic> productoMap = {
            "id": productos[i].id,
            "nombre": productos[i].nombre,
            "imagen": productos[i].imagen,
            "talla": productos[i].talla,
            "cantidad": productos[i].stock,
            "precio_unitario": productos[i].precio
          };
          await carritoCRUD
              .agregarModificarCarritoProducto(
                  idCliente, idCarrito, productos[i].id, productoMap)
              .then((val) {
            print(val.toString());
          });
        }
      });
    });
  }

  agregarModificarCarritoProducto(String idCliente, Producto producto) async {
    int idCarrito = 0;
    double total = 0;
    Map<String, dynamic> carritoMap = {
      "id": idCarrito,
      "total": total,
      "finalizado": false,
      "ultimo": true,
    };
    Map<String, dynamic> productoMap = {
      "id": producto.id,
      "nombre": producto.nombre,
      "imagen": producto.imagen,
      "descripcion": producto.descripcion,
      "talla": producto.talla,
      "cantidad": producto.stock,
      "precio_unitario": producto.precio
    };
    CarritoCRUD carritoCRUD = CarritoCRUD();
    await carritoCRUD.getUltimoCarrito(idCliente).then((val) async {
      if (val != null) {
        print("Hay datos de carritos");
        QuerySnapshot querySnapshot = val;
        if (val.size != 0) {
          print("Hay carritos");
          idCarrito = querySnapshot.docs[0].get("id");
          carritoMap = {
            "id": querySnapshot.docs[0].get("id"),
            "total": querySnapshot.docs[0].get("total"),
            "finalizado": querySnapshot.docs[0].get("finalizado"),
            "ultimo": querySnapshot.docs[0].get("ultimo"),
          };
        } else {
          print("No hay carritos");
          idCarrito = 1;
          carritoMap = {
            "id": idCarrito,
            "total": total,
            "finalizado": false,
            "ultimo": true,
          };
          await carritoCRUD
              .agregarModificarCarrito(idCliente, idCarrito.toString(), carritoMap)
              .then((val) {
            print(val.toString());
          });
        }
      } else {
        print("No hay datos de carritos");
        idCarrito = 1;
        carritoMap = {
          "id": idCarrito,
          "total": total,
          "finalizado": false,
          "ultimo": true,
        };
        await carritoCRUD
            .agregarModificarCarrito(idCliente, idCarrito.toString(), carritoMap)
            .then((val) {
          print("Carrito creado cuando no hay datos de vuelta");
          print(val.toString());
        });
      }
      if (idCarrito != 0) {
        print("El id de carrito cambió");
        print(producto.id);
        print(productoMap);
        await carritoCRUD
            .agregarModificarCarritoProducto(
                idCliente, idCarrito, producto.id, productoMap)
            .then((val) {
          print("Agregando producto..");
          print(val.toString());
        });
      }
    });
  }

  actualizarInfoUltimoCarrito(String idCliente, double total) async {
    CarritoCRUD carritoCRUD = CarritoCRUD();
    int idCarrito = 0;
    Map<String, dynamic> carritoMap = {};
    await carritoCRUD.getUltimoCarrito(idCliente).then((val){
      if(val != null){
        print("Hay datos");
        QuerySnapshot querySnapshot = val;
        if(querySnapshot.size != 0){
          print("Hay " + querySnapshot.size.toString() + " carritos");
          idCarrito = querySnapshot.docs[0].get("id");
          print("El id del carrito es $idCarrito");
        }else{
          print("No hay direcciones, se asignara como primera direccion");
          idCarrito = 1;
        }
      }else{
        print("No hay datos");
        idCarrito = 1;
      }
      carritoMap = {
        "id": idCarrito,
        "total": total,
        "finalizado": false,
        "ultimo": true,
      };
      carritoCRUD.agregarModificarCarrito(idCliente, idCarrito.toString(), carritoMap);
    });
  }

  eliminarCarrito(String idCliente, String idCarrito) {
    carritoCRUD.eliminarCarrito(idCliente, idCarrito);
  }

  eliminarCarritoProducto(String idCliente, String idCarrito, int idProducto){
    carritoCRUD.eliminarCarritoProducto(idCliente, idCarrito.toString(), idProducto.toString());
  }

}
