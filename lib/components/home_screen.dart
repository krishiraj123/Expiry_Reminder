import 'package:expiry_reminder/components/add_items_screen.dart';
import 'package:expiry_reminder/components/category_screen.dart';
import 'package:expiry_reminder/components/developer_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'add_items_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> popUpList = [
    "Sort By Default",
    "Sort By Name",
    "Sort By Expiry Date"
  ];

  List<List<dynamic>> drawerItemsList = [
    [Icons.list_alt_outlined, "All Items"],
    [Icons.view_list, "Category"],
    [Icons.shopping_cart_outlined, "Need To Buy"],
    [Icons.share_arrival_time_rounded, "Expire Soon"],
    [Icons.warning_amber_outlined, "Expired"],
    [Icons.delete_sweep_sharp, "Deleted"],
    // [FontAwesomeIcons.fileExport, "Export"],
    // [FontAwesomeIcons.fileImport, "Import"],
    [Icons.feedback_outlined, "Feedback"],
    [Icons.code, "Developer"],
    [Icons.share, "Share app"],
    [Icons.android, "More app"],
    [Icons.refresh_sharp, "Check For Updates"],
  ];
  String popUpSelectedValue = "";
  String filter = "atoz";
  List<bool> isSelectedList = List.filled(13, false);
  TextEditingController searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tempItemList =
        Provider.of<AddItemsProvider>(context, listen: false).addItemsList;
    if (isSelectedList.every((element) {
      if (element == false) {
        return true;
      }
      return false;
    })) {
      isSelectedList[0] = true;
    }

    List<Map<String, dynamic>> filteredItems =
        Provider.of<AddItemsProvider>(context).addItemsList;
    if (searchQuery.text.isNotEmpty) {
      filteredItems = filteredItems
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(0, 151, 136, 1),
        title: Text(
          "Expiry Reminder",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton(
            elevation: 10,
            color: const Color.fromRGBO(0, 151, 136, .9),
            onSelected: (val) {
              setState(() {
                popUpSelectedValue = val;
              });
            },
            icon: const Icon(
              Icons.filter_list,
              size: 35,
            ),
            itemBuilder: (BuildContext context) {
              return popUpList.map((val) {
                return PopupMenuItem(
                  child: Text(
                    val,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    if (val == "Sort By Name") {
                      setState(() {
                        Provider.of<AddItemsProvider>(context, listen: false)
                            .addItemsList
                            .sort(
                              (a, b) => a["productName"]
                                  .toString()
                                  .compareTo(b["productName"]),
                            );
                      });
                    }
                    if (val == "Sort By Expiry Date") {
                      setState(() {
                        Provider.of<AddItemsProvider>(context, listen: false)
                            .addItemsList
                            .sort(
                              (a, b) =>
                                  DateTime.parse(a["expiryDate"]).compareTo(
                                DateTime.parse(b["expiryDate"]),
                              ),
                            );
                      });
                    }
                    if (val == "Sort By Default") {
                      setState(() {
                        Provider.of<AddItemsProvider>(context, listen: false)
                            .addItemsList
                            .replaceRange(0, tempItemList.length, tempItemList);
                      });
                    }
                  },
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemPage()),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ],
      ),
      drawer: customDrawer(),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ListView.builder(
          // itemCount:
          //     Provider.of<AddItemsProvider>(context).addItemsList.length + 1,
          itemCount: filteredItems.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchQuery,
                      onChanged: (_) {
                        setState(() {});
                      },
                      cursorColor: Colors.red,
                      style: GoogleFonts.lato(
                          fontSize: 20, fontWeight: FontWeight.w600),
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
            } else {
              index -= 1;
            }
            // final item =
            //     Provider.of<AddItemsProvider>(context).addItemsList[index];
            final item = filteredItems[index];
            return SizedBox(
              // color: Colors.red,
              height: 125,
              child: Card(
                // elevation: 3,
                margin: const EdgeInsets.only(top: 15),
                child: Dismissible(
                    key: ValueKey<int>(index),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.delete),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.edit),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "Are you sure you wish to delete this item?",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<AddItemsProvider>(context,
                                                listen: false)
                                            .removeItem(item);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold))),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold))),
                                ],
                              );
                            });
                      }
                      if (direction == DismissDirection.endToStart) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddItemPage(
                                      productNameValue: item["productName"],
                                      priceValue: item["productPrice"],
                                      categoryValue: item["category"],
                                      quantityValue: item["productQuantity"],
                                      manufactureDateValue:
                                          item["manufacturingDate"],
                                      expiryDateValue: item["expiryDate"],
                                      reminderTimeValue: item["reminderTime"],
                                      reminderDateValue:
                                          item["choosedReminder"],
                                      note: item["note"],
                                      needToBuy: item["isNeeded"].toString(),
                                      buttonTextValue: "Update",
                                      indexValue: index,
                                      reminderDate: item["reminderDate"],
                                    )));
                      }
                      return false;
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: item['dayLeftInExpiry'] < 0
                                  ? Colors.red.shade300
                                  : Colors.green.shade200,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            progressColor: const Color.fromRGBO(0, 151, 136, 1),
                            lineWidth: 5,
                            percent: item['dayLeftInExpiryPercent'],
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${item["dayLeftInExpiry"] < 0 ? item["dayLeftInExpiry"] * -1 : item["dayLeftInExpiry"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade500,
                                  ),
                                ),
                                Text(
                                    "Days ${item['dayLeftInExpiry'] < 0 ? 'Ago' : 'Left'}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade700)),
                              ],
                            ),
                            backgroundColor: Colors.green.shade100,
                            backgroundWidth: 3,
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["productName"]
                                        .toString()
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Exp Date: ${item["expiryDate"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                        fontSize: 15, letterSpacing: 1.4),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (item["note"] != null)
                                    Text(
                                      item["note"],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                          fontSize: 14, letterSpacing: 1.2),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  Drawer customDrawer() {
    return Drawer(
      width: 250,
      backgroundColor: const Color.fromRGBO(0, 121, 106, 1),
      child: ListView.builder(
        itemCount: drawerItemsList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 170,
              width: double.infinity,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 121, 106, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage(
                        "assets/logos/drawer_logo.png",
                      ),
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Expiry Reminder",
                      style: GoogleFonts.lato(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "aswdc@darshan.ac.in",
                      style: GoogleFonts.lato(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            index -= 1;
            return ListTile(
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              leading: Icon(
                drawerItemsList[index][0] as IconData,
                color: Colors.white,
              ),
              title: Text(
                drawerItemsList[index][1].toString(),
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                setState(() {
                  for (int i = 0; i < isSelectedList.length; i++) {
                    isSelectedList[i] = (i == index);
                  }
                });

                // Your navigation logic here
                if (drawerItemsList[index][1] == 'Category') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryPage()),
                  );
                }
                if (drawerItemsList[index][1] == 'All Items') {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
                if (drawerItemsList[index][1] == "Developer") {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeveloperPage()));
                }
                if (drawerItemsList[index][1] == "Share app") {
                  await Share.share(
                      'https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder&pcampaignid=web_share');
                }
                if (drawerItemsList[index][1] == "Feedback") {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RatingPage()));
                }
              },
              selected: isSelectedList[index],
              selectedTileColor: Colors.black12,
              tileColor: const Color.fromRGBO(0, 151, 136, 1),
            );
          }
        },
      ),
    );
  }
}
