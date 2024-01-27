import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  static String userIsLoggedKey = 'ISUSERLOGGEDIN';
  static String userNombreKey = 'USERNOMBREKEY';
  static String userIDKey = 'USERIDKEY';
  static String userCorreoKey = 'USERCORREOKEY';

  static Future<bool> saveUserSP(bool isUserLogged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userIsLoggedKey, isUserLogged);
  }

  static Future<bool> limpiarPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> saveNombre(String nombre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNombreKey, nombre);
  }

  static Future<bool> saveIdSP(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIDKey, id);
  }

  static Future<bool> saveCorreo(String correo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userCorreoKey, correo);
  }

  static Future<bool?> getUserSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userIsLoggedKey);
  }

  static Future<String?> getNombreSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNombreKey);
  }

  static Future<String?> getIDSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIDKey);
  }

  static Future<String?> getCorreoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userCorreoKey);
  }

}