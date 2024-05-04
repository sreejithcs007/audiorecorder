import 'dart:async';


import 'package:flutter/material.dart';

import '../../homepage/view/homepageview.dart';


class Splashscreen extends StatefulWidget{
  const Splashscreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {

    Timer(const Duration(seconds: 5), () {

       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomepageScreen()), (route) => false);
    });
    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor:  Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: const AssetImage("assets/image/splashscreen.png",),width: MediaQuery.of(context).size.width*0.4,),
            Text("recorder",style: TextStyle(color: Colors.blue[800],fontSize: 25,fontWeight: FontWeight.bold),)

          ],
        ),
      ),
    );
  }

}