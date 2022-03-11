import 'package:flutter/material.dart';
import 'package:google_maps_app/home.dart';

void main() =>runApp(const MyApp());

//AIzaSyDdjQoh2lBxX_dYbDtLurrt9z2qWtKZ500
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(),
    );
  }
}
