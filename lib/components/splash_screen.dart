import 'package:expiry_reminder/components/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
      Duration(milliseconds: 2000),
      () {},
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Image.asset("assets/logos/expiry_logo.png", width: 150),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Expiry Reminder",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Color.fromRGBO(0, 151, 136, 1),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/logos/diet_logo.png",
                          width: 60,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/logos/darshan_logo.png",
                          width: 170,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image.asset(
                      "assets/logos/aswdc_logo.png",
                      width: 70,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
