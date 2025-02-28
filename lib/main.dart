import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_bloc.dart';

import 'package:post_app_with_dio/presentation/screen/splash_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PostBloc(),
      child: MaterialApp(
        home: SplashWidget(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
