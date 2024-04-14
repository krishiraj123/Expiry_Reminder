import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add new item".toUpperCase(),
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 7),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple.shade500),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white38,
                      child: Icon(
                        Icons.save,
                        size: 25,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "Save",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //-----------Name Container Starts----------------
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 2,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Enter Name :",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 30, right: 10),
                            hintText: "Enter Here",
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //------------------Name Container Ends--------------------
            //-----------------Expiry Date Starts----------------------

            //------------------Expiry Date Ends-----------------------
          ],
        ),
      ),
    );
  }
}
