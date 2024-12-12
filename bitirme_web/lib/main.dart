import 'package:bitirme_web/cubit/home_cubit.dart';
import 'package:bitirme_web/cubit/home_view.dart';
import 'package:bitirme_web/dependency_injection/locator.dart';
import 'package:bitirme_web/pages/home_page.dart';
import 'package:flutter/material.dart';


void main() {
  DependencyInjection();
  runApp(MaterialApp(
      title: "VİT",
      debugShowCheckedModeBanner: false,
      home: HomeView()));
}
