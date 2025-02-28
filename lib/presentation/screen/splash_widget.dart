import 'package:flutter/material.dart';

import 'package:post_app_with_dio/presentation/screen/home_screen.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {

    
     Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
            
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("POST APP",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),),
    );
  }
}