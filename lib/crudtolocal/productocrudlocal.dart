import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imperium/clases/producto.dart';
import 'package:imperium/crud/productocrud.dart';

class ProductoLocalCRUD{

  ProductoCRUD productoCRUD = ProductoCRUD();


  /* no usar
  List<Producto> listarProductos() {
    List<Producto> productos = [];
    print(productoCRUD.getProductos().runtimeType);

    productoCRUD.getProductos().then((val) {
      print("ESTE ES EL 1");
      QuerySnapshot querySnapshot = val;
      print(val.runtimeType);
      Producto producto;
      if(val != null) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          producto = Producto(
            int.parse(querySnapshot.docs[i].id),
            querySnapshot.docs[i].get("nombre"),
            querySnapshot.docs[i].get("descripcion"),
            querySnapshot.docs[i].get("imagen"),
            querySnapshot.docs[i].get("stock"),
            querySnapshot.docs[i].get("talla"),
            querySnapshot.docs[i].get("precio"),
          );
          productos.add(producto);
          print("Producto creado");
          print(productos[0].id);
        }
        print("ESTE ES EL 2");
        print(productos[0].nombre);
      } else {

      }
    });
    print("ESTE ES EL 3");
    print(productos[0].nombre);
    return productos;
  }

   */
  /*
  obtenerProducto(String id){
    late Producto producto;
    productoCRUD.getProductoConID(id).then((val){
      QuerySnapshot querySnapshot = val;
      if(querySnapshot.size > 0){
        producto = Producto(
          int.parse(querySnapshot.docs[0].id),
          querySnapshot.docs[0].get("nombre"),
          querySnapshot.docs[0].get("descripcion"),
          querySnapshot.docs[0].get("imagen"),
          querySnapshot.docs[0].get("stock"),
          querySnapshot.docs[0].get("talla"),
          querySnapshot.docs[0].get("precio"),
        );
      } else {
        producto = Producto(0, "error", "", "", 0, "", 0.0);
      }
    });
    return producto;
  }
   */

  agregarModificarProducto(Producto producto){
    Map<String, dynamic> productoMap = {
      "id": producto.id,
      "nombre": producto.nombre,
      "descripcion": producto.descripcion,
      "imagen": producto.imagen,
      "stock": producto.stock,
      "talla": producto.talla,
      "precio": producto.precio
    };
    productoCRUD.agregarModificarProducto(producto.id.toString(), productoMap);
  }

  eliminarProducto(String id){
    productoCRUD.eliminarProducto(id);
  }

}