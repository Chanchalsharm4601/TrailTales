import 'package:flutter/material.dart';
import 'package:trail_tales/Home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _HomeState();
}

class _HomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Image.asset(
            'asset/background.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          // Centered Text
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Centers text block in the middle
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // "Hey!  to"
                Text(
                  "Hey! Welcome to",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "NerkoOne",
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "TrailTales",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontFamily: "NerkoOne"),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: const CircleBorder(),
                        side: BorderSide(width: 4, color: Colors.white),
                        padding: EdgeInsets.all(2)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
