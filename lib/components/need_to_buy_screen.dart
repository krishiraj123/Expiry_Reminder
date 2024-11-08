import 'package:expiry_reminder/components/add_items_provider.dart';
import 'package:expiry_reminder/components/custom_swipable_card.dart';
import 'package:expiry_reminder/components/home_screen.dart';
import 'package:expiry_reminder/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NeedToBuyPage extends StatefulWidget {
  const NeedToBuyPage({super.key});

  @override
  State<NeedToBuyPage> createState() => _NeedToBuyPageState();
}

class _NeedToBuyPageState extends State<NeedToBuyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AddItemsProvider>(context, listen: false)
        .updateList()
        .then((value) {
      setState(() {});
    });
  }

  TextEditingController searchQuery = TextEditingController();
  String filter = "atoz";

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tempList = [];
    List<Map<String, dynamic>> items = tempList =
        Provider.of<AddItemsProvider>(context)
            .addItemsList
            .where((element) => element["isNeeded"] == "true")
            .toList();
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: GlobalTextSettings.pageTitleText("Need To Buy Items"),
          backgroundColor: Color.fromRGBO(0, 151, 136, 1),
          iconTheme: IconThemeData(color: Colors.white, size: 27),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
            icon: Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: tempList.isEmpty
              ? Center(
                  child: Text("No Items",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600)),
                )
              : ListView.builder(
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
      ],
    );
  }
}
