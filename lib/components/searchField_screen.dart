import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_items_provider.dart';

class SearchFieldPage extends StatefulWidget {
  final TextEditingController controllerText;

  const SearchFieldPage({super.key, required this.controllerText});

  @override
  State<SearchFieldPage> createState() => _SearchFieldPageState();
}

class _SearchFieldPageState extends State<SearchFieldPage> {
  String filter = "atoz";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controllerText,
            onChanged: (_) {
              setState(() {});
            },
            cursorColor: Colors.red,
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              hintText: "Search by name and expiry date",
              hintStyle: TextStyle(fontSize: 18),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (filter == "atoz") {
                Provider.of<AddItemsProvider>(context, listen: false)
                    .addItemsList
                    .sort(
                      (a, b) => a["productName"]
                          .toString()
                          .compareTo(b["productName"].toString()),
                    );
                filter = "ztoa";
              } else {
                Provider.of<AddItemsProvider>(context, listen: false)
                    .addItemsList
                    .sort(
                      (a, b) => b["productName"]
                          .toString()
                          .compareTo(a["productName"].toString()),
                    );
                filter = "atoz";
              }
            });
          },
          icon: (filter == "atoz")
              ? const FaIcon(
                  FontAwesomeIcons.arrowDownAZ,
                  size: 30,
                )
              : const FaIcon(
                  FontAwesomeIcons.arrowUpAZ,
                  size: 30,
                ),
        )
      ],
    );
  }
}
