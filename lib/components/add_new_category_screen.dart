import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'category_provider.dart';

class AddCategoryPage extends StatefulWidget {
  final String? category;
  final int? itemIndex;

  const AddCategoryPage({super.key, this.category, this.itemIndex});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = TextEditingController(text: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        height: 200,
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(0, 151, 136, 1),
              child: Text(
                "Add Category",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: category,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (RegExp(r"^[0-9]").hasMatch(value!)) {
                    return "Category Cannot Begin with digits";
                  }
                  return null;
                },
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  labelText: "Category\*",
                  labelStyle: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelStyle: const TextStyle(color: Colors.black54),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 121, 106, 1),
                    ),
                    onPressed: () async {
                      if (widget.category == null) {
                        // if (!Provider.of<CategoryProvider>(context,
                        //             listen: false)
                        //         .dropDownMenuCategoryItemsList
                        //         .contains(category.text.trim()) &&
                        //     category.text.trim().isNotEmpty) {
                        //   Provider.of<CategoryProvider>(context, listen: false)
                        //       .addCategory(category.text);

                        // await MyDatabase()
                        //     .insertDataIntoCategory(category.text.trim());

                        Provider.of<CategoryProvider>(context, listen: false)
                            .addCategory(category.text.trim());
                        // }
                        Navigator.of(context).pop(true);
                      } else {
                        // if (!Provider.of<CategoryProvider>(context,
                        //             listen: false)
                        //         .dropDownMenuCategoryItemsList
                        //         .contains(category.text.trim()) &&
                        //     category.text.trim().isNotEmpty) {
                        //   Provider.of<CategoryProvider>(context, listen: false)
                        //       .updateCategory(category.text, widget.itemIndex);
                        // await MyDatabase().updateCategory(
                        //     category.text.trim(), widget.itemIndex!);
                        Provider.of<CategoryProvider>(context, listen: false)
                            .updateCategory(
                                category.text.trim(), widget.itemIndex);
                        // }
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text(
                      widget.category == null ? "Add" : "Update",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "cancel",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
