import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class Oops extends StatefulWidget {
  const Oops({Key? key}) : super(key: key);

  @override
  State<Oops> createState() => _OopsState();
}

class _OopsState extends State<Oops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 43, 75, 129),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '''Oops The App was not designed for large screen sizes. 
                \nYou can  still enjoy the full features by clicking continue. 
                \nBut you may not like what you see ''',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: (() => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Home()))),
                child: const Bubble(
                    color: Color.fromARGB(255, 2, 39, 70),
                    width: 300,
                    height: 150,
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              )
            ],
          ),
        ));
  }
}
