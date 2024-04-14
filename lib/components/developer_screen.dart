import 'package:aswdc_flutter_pub/aswdc_flutter_pub.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DeveloperScreen(
      developerName: "Krishirajsinh Vansia(22010101200)",
      mentorName: "Mehul Bhundiya",
      exploredByName: "ASWDC",
      isAdmissionApp: false,
      shareMessage: "Darshan",
      appTitle: "Expiry Reminder",
      appLogo: "assets/logos/expiry_logo.png",
      textColor: Color.fromRGBO(0, 151, 136, 1),
      appBarColor: Color.fromRGBO(0, 151, 136, 1),
      backgroundColor: Colors.grey.shade300,
      colorValue: Color.fromRGBO(0, 151, 136, 1),
      isDBUpdate: false,
    ));
  }
}
