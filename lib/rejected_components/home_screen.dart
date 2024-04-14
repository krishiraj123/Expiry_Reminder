import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Expiry Date",
              style:
                  GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Text(
              "Alerts & Reminders".toUpperCase(),
              style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30,right: 30,top: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("lib/assets/logos/expiry_logo.png"),
                  width: 120,
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Items",
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            //items add section starts
            addItems("lib/assets/images/list_image.png", "All Items", 0),
            addItems("lib/assets/images/sand_clock_image.png", "Expire Soon", 0),
            addItems("lib/assets/images/calender_image.png", "Expired", 0),
            //items add section ends
          ],
        ),
      ),
    );
  }
}

Widget addItems(String imageUrl, String title, int count) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: Card(
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage(imageUrl),
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(title,style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),),
                SizedBox(
                  width: 20,
                ),
                Text(count.toString(),style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
              ],
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    ),
  );
}
