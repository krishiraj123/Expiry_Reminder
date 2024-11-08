import 'package:expiry_reminder/components/add_items_screen.dart';
import 'package:expiry_reminder/components/category_screen.dart';
import 'package:expiry_reminder/components/custom_swipable_card.dart';
import 'package:expiry_reminder/components/deleted_screen.dart';
import 'package:expiry_reminder/components/developer_screen.dart';
import 'package:expiry_reminder/components/expire_soon_screen.dart';
import 'package:expiry_reminder/components/expired_screen.dart';
import 'package:expiry_reminder/components/need_to_buy_screen.dart';
import 'package:expiry_reminder/components/rating_screen.dart';
import 'package:expiry_reminder/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/reminder.dart';
import 'add_items_provider.dart';

class HomePage extends StatefulWidget {
  static const route = "/home";

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

  bool wantToExit = false;

  List<List<dynamic>> drawerItemsList = [
    [Icons.list_alt_outlined, "All Items"],
    [Icons.view_list, "Category"],
    [Icons.shopping_cart_outlined, "Need To Buy"],
    [Icons.share_arrival_time_rounded, "Expire Soon"],
    [Icons.warning_amber_outlined, "Expired"],
    [Icons.delete_sweep_sharp, "Deleted"],
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
    // MyDatabase().updateDayLeftForAllProducts().then((value) {
    //   setState(() {});
    // });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the image here, now the context is valid
    precacheImage(AssetImage("assets/logos/main_app_logo.png"), context);
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

    // filteredItems.sort((a, b) {
    //   DateTime d1 = DateTime.parse(a["expiryDate"]);
    //   DateTime d2 = DateTime.parse(b["expiryDate"]);
    //   return d1.compareTo(d2);
    // });

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
    bool canPop = false;

    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(0, 151, 136, 1),
          title: GlobalTextSettings.pageTitleText("Expiry Reminder"),
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
                size: 28,
              ),
              itemBuilder: (BuildContext context) {
                return popUpList.map((val) {
                  return PopupMenuItem(
                    child: Text(
                      val,
                      textScaler: TextScaler.linear(1),
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      final addItemsProvider =
                          Provider.of<AddItemsProvider>(context, listen: false);

                      if (val == "Sort By Name") {
                        addItemsProvider.updateList().then((_) {
                          List<Map<String, dynamic>> mutableList =
                              List<Map<String, dynamic>>.from(
                                  addItemsProvider.addItemsList);
                          mutableList.sort((a, b) => a["productName"]
                              .toString()
                              .compareTo(b["productName"].toString()));
                          addItemsProvider.addItemsList = mutableList;
                        });
                      }

                      if (val == "Sort By Expiry Date") {
                        addItemsProvider.updateList().then((_) {
                          List<Map<String, dynamic>> mutableList =
                              List<Map<String, dynamic>>.from(
                                  addItemsProvider.addItemsList);
                          mutableList.sort((a, b) {
                            final dateA = DateTime.tryParse(a["expiryDate"]) ??
                                DateTime.now();
                            final dateB = DateTime.tryParse(b["expiryDate"]) ??
                                DateTime.now();
                            return dateA.compareTo(dateB);
                          });
                          addItemsProvider.addItemsList = mutableList;
                        });
                      }

                      if (val == "Sort By Default") {
                        addItemsProvider.updateList().then((_) {
                          List<Map<String, dynamic>> mutableList =
                              List<Map<String, dynamic>>.from(
                                  addItemsProvider.addItemsList);
                          mutableList.sort((a, b) => a["productName"]
                              .toString()
                              .compareTo(b["productName"].toString()));
                          addItemsProvider.addItemsList = mutableList;
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    hintText: "Search by name or expiry date",
                                    hintStyle: TextStyle(fontSize: 16.5),
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
                                        size: 28,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.arrowUpAZ,
                                        size: 28,
                                      ),
                              )
                            ],
                          ),
                        ],
                      );
                    } else {
                      final item = filteredItems[index - 1];
                      return CustomSwipeCard(
                        index: index - 1,
                        item: item,
                      );
                    }
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
        width: 245,
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
                      Image(
                        image: AssetImage(
                          "assets/logos/compressed_main_app_logo.png",
                        ),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Expiry Reminder",
                        textScaler: TextScaler.linear(1),
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
                        textScaler: TextScaler.linear(1),
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
                  textScaler: TextScaler.linear(1),
                  style: GoogleFonts.lato(
                    fontSize: 17.5,
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

                  if (drawerItemsList[index][1] == 'All Items') {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  if (drawerItemsList[index][1] == 'Category') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryPage()),
                    );
                  }
                  if (drawerItemsList[index][1] == "Developer") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => DeveloperPage()),
                    );
                  }
                  if (drawerItemsList[index][1] == "Share app") {
                    await Share.share(
                        'https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder&pcampaignid=web_share');
                    Navigator.of(context).pop();
                  }
                  if (drawerItemsList[index][1] == "Feedback") {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RatingPage()));
                    Navigator.of(context).pop();
                    RatingPage().rateApp(context);
                  }
                  if (drawerItemsList[index][1] == "Deleted") {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DeletedPage()));
                  }
                  if (drawerItemsList[index][1] == "Expired") {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ExpiredPage()));
                  }
                  if (drawerItemsList[index][1] == "Need To Buy") {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => NeedToBuyPage()));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NeedToBuyPage()));
                  }
                  if (drawerItemsList[index][1] == "Check For Updates") {
                    // StoreRedirect.redirect(
                    //     androidAppId: 'com.aswdc_ExpiryReminder',
                    //     iOSAppId: 'com.example.expiryReminder');
                    String playStoreLink =
                        "https://play.google.com/store/apps/details?id=com.aswdc_ExpiryReminder";
                    launchUrl(Uri.parse(playStoreLink));
                    Navigator.of(context).pop();
                  }
                  if (drawerItemsList[index][1] == "More apps") {
                    String playStoreLink =
                        "https://play.google.com/store/apps/developer?id=Darshan+University";
                    launchUrl(Uri.parse(playStoreLink));
                    Navigator.of(context).pop();
                  }
                  if (drawerItemsList[index][1] == "Expire Soon") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ExpireSoonPage()));
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
