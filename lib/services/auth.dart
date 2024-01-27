import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imperium/widgets/widgets.dart';

class AuthMethods{
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future createUserWithEmailAndPassword(context, String correo, String password) async {
    print("CREAR");
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: correo,
          password: password
      );
      print(userCredential);
      Navigator.pushReplacementNamed(context, "/pantallaPrincipalCliente");
      return userCredential.user?.email;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      return null;
      print(e);
    }
  }

  Future signInWithEmailAndPassword(context, String correo, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: correo,
          password: password
      );
      Navigator.pushReplacementNamed(context, "/pantallaPrincipalCliente");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se encuentra este usuario en la base de datos');
      } else if (e.code == 'wrong-password') {
        print('La contraseña es incorrecta');
        notificacion(context, "La contraseña es incorrecta");
      }
    }
  }

  Future resetPass(String correo) async {
    try {
      return await FirebaseAuth.instance.sendPasswordResetEmail(
          email: correo,
      );
    }  catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

}