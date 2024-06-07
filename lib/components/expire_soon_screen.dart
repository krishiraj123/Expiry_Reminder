import 'package:expiry_reminder/components/custom_swipable_card.dart';
import 'package:expiry_reminder/components/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_items_provider.dart';

class ExpireSoonPage extends StatefulWidget {
  const ExpireSoonPage({super.key});

  @override
  State<ExpireSoonPage> createState() => _ExpireSoonPageState();
}

class _ExpireSoonPageState extends State<ExpireSoonPage> {
  String filter = "atoz";
  TextEditingController searchQuery = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late List<Map<String, dynamic>> items = [];
    late List<Map<String, dynamic>> tempList = [];
    if (fromDate.text.isNotEmpty && toDate.text.isNotEmpty) {
      items = tempList = Provider.of<AddItemsProvider>(context)
          .addItemsList
          .where((element) =>
              DateTime.parse(element["expiryDate"])
                      .isAfter(DateTime.parse(fromDate.text)) &&
                  DateTime.parse(element["expiryDate"])
                      .isBefore(DateTime.parse(toDate.text)) ||
              (DateTime.parse(element["expiryDate"])
                      .isAtSameMomentAs(DateTime.parse(fromDate.text)) ||
                  DateTime.parse(element["expiryDate"])
                      .isAtSameMomentAs(DateTime.parse(toDate.text))))
          .toList();
    }

    if (searchQuery.text.isNotEmpty) {
      items = items
          .where((element) =>
              element["productName"]
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.text.toLowerCase()) ||
              element["expiryDate"]
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.text.toLowerCase()))
          .toList();
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Expire Soon"),
        backgroundColor: Color.fromRGBO(0, 151, 136, 1),
        titleTextStyle: GoogleFonts.lato(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
          },
          icon: Icon(
            Icons.arrow_back,
            size: 27,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 27),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: ListView.builder(
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return customSearch(context);
            } else
              return CustomSwipeCard(
                item: items[index - 1],
                index: index - 1,
              );
          },
        ),
      ),
    );
  }

  Widget customSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: searchQuery,
                onChanged: (_) {
                  setState(() {});
                },
                cursorColor: Colors.red,
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
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
                    final List<Map<String, dynamic>> itemList = List.from(
                        Provider.of<AddItemsProvider>(context, listen: false)
                            .addItemsList);
                    setState(() {
                      itemList.sort((a, b) => a["productName"]
                          .toString()
                          .compareTo(b["productName"]));
                      Provider.of<AddItemsProvider>(context, listen: false)
                          .addItemsList = itemList;
                    });
                    filter = "ztoa";
                  } else {
                    final List<Map<String, dynamic>> itemList = List.from(
                        Provider.of<AddItemsProvider>(context, listen: false)
                            .addItemsList);
                    setState(() {
                      itemList.sort((a, b) => b["productName"]
                          .toString()
                          .compareTo(a["productName"]));
                      Provider.of<AddItemsProvider>(context, listen: false)
                          .addItemsList = itemList;
                    });
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
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: fromDate,
                onChanged: (_) {
                  setState(() {});
                },
                onTap: () async {
                  final _pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (_pickedDate != null) {
                    setState(() {
                      fromDate.text = _pickedDate.toString().split(" ")[0];
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "From",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: toDate,
                onChanged: (_) {
                  setState(() {});
                },
                onTap: () async {
                  final _pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (_pickedDate != null) {
                    setState(() {
                      toDate.text = _pickedDate.toString().split(" ")[0];
                    });
                  }
                  if (DateTime.parse(toDate.text)
                          .difference(DateTime.parse(fromDate.text))
                          .inDays
                          .isNegative ||
                      DateTime.parse(fromDate.text)
                              .difference(DateTime.parse(toDate.text))
                              .inDays >
                          0) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Invalid Date Range"),
                        content: Text(
                          "Please select a valid date range. The 'To' date should be greater than or equal to the 'From' date.",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    setState(() {
                      fromDate.text = "";
                      toDate.text = "";
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "To",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
