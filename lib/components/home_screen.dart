import 'package:expiry_reminder/components/add_items_screen.dart';
import 'package:expiry_reminder/components/category_screen.dart';
import 'package:expiry_reminder/components/custom_swipable_card.dart';
import 'package:expiry_reminder/components/deleted_screen.dart';
import 'package:expiry_reminder/components/developer_screen.dart';
import 'package:expiry_reminder/components/expired_screen.dart';
import 'package:expiry_reminder/components/need_to_buy_screen.dart';
import 'package:expiry_reminder/components/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/reminder.dart';
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
    [Icons.android, "More apps"],
    [Icons.refresh_sharp, "Check For Updates"],
  ];
  String popUpSelectedValue = "";
  String filter = "atoz";
  List<bool> isSelectedList = List.filled(13, false);
  TextEditingController searchQuery = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AddItemsProvider>(context, listen: false)
        .updateList()
        .then((value) {
      setState(() {});
    });
    MyDatabase().updateDayLeftForAllProducts().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSelectedList.every((element) {
      if (element == false) {
        return true;
      }
      return false;
    })) {
      isSelectedList[0] = true;
    }

    List<Map<String, dynamic>> filteredItems =
        Provider.of<AddItemsProvider>(context)
            .addItemsList
            .where((element) => element["isDeleted"] == "false")
            .toList();
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
              fontSize: 20,
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
                        final List<Map<String, dynamic>> itemList = List.from(
                            Provider.of<AddItemsProvider>(context,
                                    listen: false)
                                .addItemsList);
                        setState(() {
                          itemList.sort((a, b) => a["productName"]
                              .toString()
                              .compareTo(b["productName"]));
                          Provider.of<AddItemsProvider>(context, listen: false)
                              .addItemsList = itemList;
                        });
                      }
                      if (val == "Sort By Expiry Date") {
                        final List<Map<String, dynamic>> itemList = List.from(
                            Provider.of<AddItemsProvider>(context,
                                    listen: false)
                                .addItemsList);
                        setState(() {
                          itemList.sort((a, b) =>
                              DateTime.parse(a["expiryDate"])
                                  .compareTo(DateTime.parse(b["expiryDate"])));
                          Provider.of<AddItemsProvider>(context, listen: false)
                              .addItemsList = itemList;
                        });
                      }
                      if (val == "Sort By Default") {
                        setState(() {
                          Provider.of<AddItemsProvider>(context, listen: false)
                              .updateList()
                              .then((_) {
                            final List<Map<String, dynamic>> itemList =
                                List.from(Provider.of<AddItemsProvider>(context,
                                        listen: false)
                                    .addItemsList);
                            itemList.sort((a, b) => a["productName"]
                                .toString()
                                .compareTo(b["productName"]));
                            Provider.of<AddItemsProvider>(context,
                                    listen: false)
                                .addItemsList = itemList;
                          });
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
                ).then((value) {
                  setState(() {});
                });
                setState(() {});
              },
              icon: const Icon(
                Icons.add,
                size: 35,
              ),
            ),
          ],
        ),
        drawer: customDrawer(),
        body: FutureBuilder(
          future: MyDatabase().copyPasteAssetFileToRoot(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ListView.builder(
                  // itemCount:
                  //     Provider.of<AddItemsProvider>(context).addItemsList.length + 1,
                  itemCount: filteredItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
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
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    hintText: "Search by name and expiry date",
                                    hintStyle: TextStyle(fontSize: 18),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (filter == "atoz") {
                                      final List<Map<String, dynamic>>
                                          itemList = List.from(
                                              Provider.of<AddItemsProvider>(
                                                      context,
                                                      listen: false)
                                                  .addItemsList);
                                      setState(() {
                                        itemList.sort((a, b) => a["productName"]
                                            .toString()
                                            .compareTo(b["productName"]));
                                        Provider.of<AddItemsProvider>(context,
                                                listen: false)
                                            .addItemsList = itemList;
                                      });
                                      filter = "ztoa";
                                    } else {
                                      final List<Map<String, dynamic>>
                                          itemList = List.from(
                                              Provider.of<AddItemsProvider>(
                                                      context,
                                                      listen: false)
                                                  .addItemsList);
                                      setState(() {
                                        itemList.sort((a, b) => b["productName"]
                                            .toString()
                                            .compareTo(a["productName"]));
                                        Provider.of<AddItemsProvider>(context,
                                                listen: false)
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
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(
                              "*Swipe the card left or right",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    } else {
                      index -= 1;
                    }
                    // final item =
                    //     Provider.of<AddItemsProvider>(context).addItemsList[index];
                    final item = filteredItems[index];
                    return CustomSwipeCard(
                      index: index,
                      item: item,
                    );
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget customDrawer() {
    return SafeArea(
      child: Drawer(
        width: 250,
        // backgroundColor: const Color.fromRGBO(0, 121, 106, 1),
        backgroundColor: Color.fromRGBO(0, 151, 136, 1),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DeveloperPage()));
                  }
                  if (drawerItemsList[index][1] == "Share app") {
                    await Share.share(
                        'https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder&pcampaignid=web_share');
                  }
                  if (drawerItemsList[index][1] == "Feedback") {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RatingPage()));
                    Navigator.of(context).pop();
                    RatingPage().rateApp(context);
                  }
                  if (drawerItemsList[index][1] == "Deleted") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DeletedPage()));
                  }
                  if (drawerItemsList[index][1] == "Expired") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ExpiredPage()));
                  }
                  if (drawerItemsList[index][1] == "Need To Buy") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NeedToBuyPage()));
                  }
                  if (drawerItemsList[index][1] == "Check For Updates") {
                    // StoreRedirect.redirect(
                    //     androidAppId: 'com.aswdc_ExpiryReminder',
                    //     iOSAppId: 'com.example.expiryReminder');
                    String playStoreLink =
                        "https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder";
                    launchUrl(Uri.parse(playStoreLink));
                  }
                  if (drawerItemsList[index][1] == "More apps") {
                    String playStoreLink =
                        "https://play.google.com/store/apps/developer?id=Darshan+University";
                    launchUrl(Uri.parse(playStoreLink));
                  }
                },
                selected: isSelectedList[index],
                selectedTileColor: Colors.black12,
                tileColor: const Color.fromRGBO(0, 151, 136, 1),
              );
            }
          },
        ),
      ),
    );
  }
}
