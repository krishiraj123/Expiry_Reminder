import 'package:expiry_reminder/components/add_new_category_screen.dart';
import 'package:expiry_reminder/database/reminder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> commands = ['Edit', 'Delete'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<CategoryProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 151, 136, 1),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(size: 25, color: Colors.white),
        title: Text(
          "Category",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) => AddCategoryPage()).then((value) {
                  if (value) {
                    setState(() {});
                  }
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
                          // Provider.of<CategoryProvider>(context)
                          //     .dropDownMenuCategoryItemsList
                          //     .length -
                          //     1,
                          itemBuilder: (context, index) {
                            index++;
                            final item = snapshot1.data![index]["C_Category"];
                            // Provider.of<CategoryProvider>(context)
                            //     .dropDownMenuCategoryItemsList[index];
                            return PopupMenuButton(
                                color: Color.fromRGBO(0, 151, 136, 1),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${index}.   ${item}",
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
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            onTap: () async {
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
                                                MyDatabase().deleteCategory(
                                                    snapshot1.data![index]
                                                        ["C_ID"]);
                                                setState(() {});
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
                                              if (val.toLowerCase() == 'edit') {
                                                // if (Provider.of<CategoryProvider>(
                                                //             context,
                                                //             listen: false)
                                                //         .checkIsTrue(item) ==
                                                //     false) {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AddCategoryPage(
                                                          category: item,
                                                          itemIndex: snapshot1
                                                                  .data![index]
                                                              ["C_ID"],
                                                        )).then((value) {
                                                  if (value) {
                                                    setState(() {});
                                                  }
                                                });
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
                      return const Center(child: CircularProgressIndicator());
                    }
                  });
            } else {
              return Text("Failed to load data");
            }
          }),
    );
  }
}
