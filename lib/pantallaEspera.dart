import 'package:flutter/material.dart';

class PantallaEspera extends StatefulWidget {
  const PantallaEspera({Key? key}) : super(key: key);

  @override
  _PantallaEsperaState createState() => _PantallaEsperaState();
}

class _PantallaEsperaState extends State<PantallaEspera> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: const Text(
              "Cargando...",
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 20,
              ),
            ),
          ),
          const LinearProgressIndicator(
            color: Colors.indigo,
            backgroundColor: Colors.white,
          )
        ],
      ),
    );
  }
}
