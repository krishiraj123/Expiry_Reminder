import 'package:expiry_reminder/components/add_items_provider.dart';
import 'package:expiry_reminder/components/add_new_category_screen.dart';
import 'package:expiry_reminder/components/home_screen.dart';
import 'package:expiry_reminder/components/info_detail_screen.dart';
import 'package:expiry_reminder/database/reminder.dart';
import 'package:expiry_reminder/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> commands = ['Info', 'Edit', 'Delete'];
  Set<String> categories = {};

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items =
        Provider.of<AddItemsProvider>(context).addItemsList;
    categories.clear();
    for (var i in items) {
      categories.add(i["category"]);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 151, 136, 1),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(size: 25, color: Colors.white),
          title: GlobalTextSettings.pageTitleText("Category"),
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
          actions: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AddCategoryPage()).then((value) {
                    setState(() {});
                  });
                },
                icon: Icon(
                  Icons.add,
                  size: 40,
                ))
          ],
        ),
        body: FutureBuilder(
            future: MyDatabase().copyPasteAssetFileToRoot(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder(
                    future: MyDatabase().getDataFromCategory(),
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            itemCount: snapshot1.data!.length - 1,
                            itemBuilder: (context, index) {
                              index++;
                              final item = snapshot1.data![index]["C_Category"];
                              return PopupMenuButton(
                                  color: Color.fromRGBO(0, 151, 136, 1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${index}.   ${item}",
                                          textScaler: TextScaler.linear(1),
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context) {
                                    return commands
                                        .map((val) {
                                          return PopupMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                                textScaler:
                                                    TextScaler.linear(1),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              onTap: () async {
                                                if (val.toLowerCase() ==
                                                    'info') {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        InfoDetailPage(
                                                      catergory: item,
                                                    ),
                                                  ));
                                                }
                                                if (val.toLowerCase() ==
                                                    'delete') {
                                                  // if (Provider.of<CategoryProvider>(
                                                  //             context,
                                                  //             listen: false)
                                                  //         .checkIsTrue(item) ==
                                                  //     false) {
                                                  //   Provider.of<CategoryProvider>(
                                                  //           context,
                                                  //           listen: false)
                                                  //       .removeCategory(
                                                  //           item,
                                                  //           snapshot1.data![index]
                                                  //               ["C_ID"]);
                                                  if (categories
                                                      .contains(item)) {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        content: Text(
                                                          "$item is already in use, so it can't be deleted.",
                                                          textScaler:
                                                              TextScaler.linear(
                                                                  1),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Ok",
                                                              textScaler:
                                                                  TextScaler
                                                                      .linear(
                                                                          1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    MyDatabase().deleteCategory(
                                                        snapshot1.data![index]
                                                            ["C_ID"]);
                                                    setState(() {});
                                                  }
                                                }
                                                // else {
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (context) {
                                                //           return AlertDialog(
                                                //             title: Text(
                                                //               "The given category is in use so It can't be Deleted",
                                                //               style: TextStyle(
                                                //                   fontSize: 17,
                                                //                   fontWeight:
                                                //                       FontWeight.w600),
                                                //             ),
                                                //             actions: [
                                                //               TextButton(
                                                //                   onPressed: () {
                                                //                     Navigator.of(
                                                //                             context)
                                                //                         .pop();
                                                //                   },
                                                //                   child: Text("Ok"))
                                                //             ],
                                                //           );
                                                //         });
                                                //   }
                                                // }
                                                if (val.toLowerCase() ==
                                                    'edit') {
                                                  // if (Provider.of<CategoryProvider>(
                                                  //             context,
                                                  //             listen: false)
                                                  //         .checkIsTrue(item) ==
                                                  //     false) {
                                                  if (categories
                                                      .contains(item)) {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        content: Text(
                                                          "$item is already in use, so it can't be Edited.",
                                                          textScaler:
                                                              TextScaler.linear(
                                                                  1),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Ok",
                                                              textScaler:
                                                                  TextScaler
                                                                      .linear(
                                                                          1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AddCategoryPage(
                                                              category: item,
                                                              itemIndex:
                                                                  snapshot1.data![
                                                                          index]
                                                                      ["C_ID"],
                                                            )).then((value) {
                                                      setState(() {});
                                                    });
                                                  }
                                                }
                                                // else {
                                                //   showDialog(
                                                //       context: context,
                                                //       builder: (context) {
                                                //         return AlertDialog(
                                                //           title: Text(
                                                //             "The given category is in use so It can't be Edited",
                                                //             style: TextStyle(
                                                //                 fontSize: 17,
                                                //                 fontWeight:
                                                //                 FontWeight.w600),
                                                //           ),
                                                //           actions: [
                                                //             TextButton(
                                                //                 onPressed: () {
                                                //                   Navigator.of(
                                                //                       context)
                                                //                       .pop();
                                                //                 },
                                                //                 child: Text("Ok"))
                                                //           ],
                                                //         );
                                                //       });
                                                // }
                                              });
                                        })
                                        .toSet()
                                        .toList();
                                  });
                            },
                          ),
                        );
                      } else {
                        print("from else of builder 2");
                        return const Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return Text(
                  "Failed to load data",
                  textScaler: TextScaler.linear(1),
                );
              }
            }),
      ),
    );
  }
}
