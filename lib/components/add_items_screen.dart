import 'package:expiry_reminder/api/notifications.dart';
import 'package:expiry_reminder/components/add_items_provider.dart';
import 'package:expiry_reminder/components/category_provider.dart';
import 'package:expiry_reminder/database/reminder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

List<dynamic> dropDownMenuReminderItemsList = [
  "Choose Reminder Date",
  "Never",
  "On Specific Date",
  "1 Day Before",
  "2 Day Before",
  "3 Day Before",
  "1 Week Before",
  "2 Week Before",
  "1 Month Before",
];
final _formKey = GlobalKey<FormState>();
int globalCounter = 0;

class AddItemPage extends StatefulWidget {
  final String? productNameValue;
  final String? priceValue;
  final String? categoryValue;
  final String? quantityValue;
  final String? manufactureDateValue;
  final String? expiryDateValue;
  final String? reminderTimeValue;
  final String? reminderDateValue;
  final String? note;
  final String needToBuy;
  final String? buttonTextValue;
  final int indexValue;
  final String? reminderDate;
  final bool isEnabled;

  const AddItemPage(
      {Key? key,
      this.productNameValue,
      this.priceValue,
      this.categoryValue,
      this.quantityValue,
      this.manufactureDateValue,
      this.expiryDateValue,
      this.reminderTimeValue,
      this.reminderDateValue,
      this.note,
      this.needToBuy = "false",
      this.buttonTextValue,
      this.indexValue = 0,
      this.reminderDate,
      this.isEnabled = true});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late String selectedCategoryValueOfDropDownList;
  late TextEditingController productName;
  late TextEditingController price;
  late TextEditingController quantity;
  late TextEditingController Note;
  late TextEditingController manufacturingDateValue;
  late TextEditingController reminderDate;
  late TextEditingController expiryDateValue;
  late TextEditingController reminderTimeValue;
  late TextEditingController category;
  String? specificDateValue;
  late String selectedReminderDropDownValue;
  late String isSwitchActive;
  late String buttonText;
  late int index;
  String? selectedSpecificDate = null;

  @override
  void initState() {
    super.initState();
    _fetch();
    selectedCategoryValueOfDropDownList =
        widget.categoryValue ?? "Choose Category";
    productName = TextEditingController(text: widget.productNameValue);
    price = TextEditingController(text: widget.priceValue);
    quantity = TextEditingController(text: widget.quantityValue);
    Note = TextEditingController(text: widget.note);
    manufacturingDateValue =
        TextEditingController(text: widget.manufactureDateValue);
    expiryDateValue = TextEditingController(text: widget.expiryDateValue);
    reminderTimeValue = TextEditingController(text: widget.reminderTimeValue);
    category = TextEditingController(text: widget.categoryValue);
    reminderDate = TextEditingController(text: widget.reminderDate);
    selectedReminderDropDownValue =
        widget.reminderDateValue ?? dropDownMenuReminderItemsList[0];
    isSwitchActive = widget.needToBuy;
    buttonText = widget.buttonTextValue ?? "Add";
    index = widget.indexValue;
  }

  Future<void> _fetch() async {
    await Provider.of<CategoryProvider>(context, listen: false).fetchData();
  }

  @override
  void dispose() {
    productName.dispose();
    price.dispose();
    quantity.dispose();
    Note.dispose();
    manufacturingDateValue.dispose();
    expiryDateValue.dispose();
    reminderTimeValue.dispose();
    category.dispose();
    super.dispose();
  }

  double percentageDaysLeft(String date) {
    DateTime now = DateTime.now();
    DateTime expiryDate;
    try {
      expiryDate = DateTime.parse(date);
    } catch (e) {
      print("Invalid date format: $date");
      return 0.0;
    }

    int daysLeft = (expiryDate.difference(now).inMinutes / 1440.0).ceil();

    if (daysLeft < 0) {
      return 1.0;
    } else if (daysLeft == 0) {
      return 1.0;
    }
    return 1 - (daysLeft / (daysLeft + 2));
  }

  DateTime? reminderDateFinder(String dropDownValue, DateTime expiryDate) {
    List<String> value = dropDownValue.split(" ");
    DateTime? reminderDate = DateTime.now();

    if (dropDownValue != "Never" &&
        dropDownValue != "Choose Reminder Date" &&
        dropDownValue != "On Specific Date") {
      if (value[1] == "Day") {
        reminderDate = expiryDate.subtract(Duration(days: int.parse(value[0])));
      }
      if (value[1] == "Week") {
        reminderDate =
            expiryDate.subtract(Duration(days: int.parse(value[0]) * 7));
      }
      if (value[1] == "Month") {
        reminderDate =
            expiryDate.subtract(Duration(days: int.parse(value[0]) * 30));
      }
    } else {
      return null;
    }
    return reminderDate;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isEnabled ? false : true,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        popAlertDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 151, 136, 1),
          iconTheme: const IconThemeData(color: Colors.white, size: 28),
          title: Text(
            "Add Item",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                child: Card(
                  shape: const RoundedRectangleBorder(),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: productName,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter a value';
                                  }
                                  if (RegExp(r'^[0-9]').hasMatch(value!)) {
                                    return 'Name cannot be starts with number';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9]+$')
                                      .hasMatch(value.trim())) {
                                    return 'Name should only contain alphabets and numbers';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Name\*",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                cursorColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        //----------------------Price Section----------------------
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.tag,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
                                      return "Please Enter Only Digits";
                                    }
                                  }
                                  return null;
                                },
                                controller: price,
                                decoration: InputDecoration(
                                  labelText: "Price",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                cursorColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //----------------------------Category Section-------------------
                        Row(
                          children: [
                            const Icon(
                              Icons.view_list,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                borderRadius: BorderRadius.circular(10),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == "Choose Category") {
                                    return "Please Select the value";
                                  }
                                  return null;
                                },
                                menuMaxHeight: 400,
                                value: selectedCategoryValueOfDropDownList,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                  ),
                                ),
                                dropdownColor: Colors.grey.shade300,
                                style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                                iconSize: 40,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCategoryValueOfDropDownList =
                                        newValue.toString();
                                  });
                                  // print(Provider.of<CategoryProvider>(context,
                                  //         listen: false)
                                  //     .isInUse);
                                },
                                items: Provider.of<CategoryProvider>(context,
                                        listen: true)
                                    .dropDownMenuCategoryItemsList
                                    .map((value) {
                                  return DropdownMenuItem(
                                    enabled: widget.isEnabled,
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Container(
                                            height: 200,
                                            width: 350,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  color: const Color.fromRGBO(
                                                      0, 151, 136, 1),
                                                  child: Text(
                                                    "Add Category",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: TextFormField(
                                                    controller: category,
                                                    enabled: widget.isEnabled,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) {
                                                      if (RegExp(r"^[0-9]")
                                                          .hasMatch(value!)) {
                                                        return "Category Cannot Begin with digits";
                                                      }
                                                      return null;
                                                    },
                                                    cursorColor: Colors.red,
                                                    decoration: InputDecoration(
                                                      border:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      labelText: "Category\*",
                                                      labelStyle:
                                                          GoogleFonts.lato(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 7),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(0,
                                                                  121, 106, 1),
                                                        ),
                                                        onPressed:
                                                            !widget.isEnabled
                                                                ? null
                                                                : () {
                                                                    if (!Provider.of<CategoryProvider>(context, listen: false).dropDownMenuCategoryItemsList.contains(category
                                                                            .text
                                                                            .toLowerCase()
                                                                            .trim()) &&
                                                                        category
                                                                            .text
                                                                            .trim()
                                                                            .isNotEmpty) {
                                                                      // Provider.of<CategoryProvider>(
                                                                      //         context,
                                                                      //         listen: false)
                                                                      //     .addCategory(
                                                                      //         category
                                                                      //             .text);
                                                                      MyDatabase().insertDataIntoCategory(category
                                                                          .text
                                                                          .trim());
                                                                      category.text =
                                                                          "";
                                                                      // Provider.of<
                                                                      //     CategoryProvider>(
                                                                      //   context,
                                                                      //   listen: false,
                                                                      // ).notifyListeners();
                                                                    }
                                                                    Provider.of<CategoryProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .fetchData();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                        child: Text(
                                                          "Add",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: Text(
                                                          "cancel",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.add_box,
                                  size: 30,
                                  color: Color.fromRGBO(0, 121, 106, 1),
                                )),
                          ],
                        ),
                        //--------------------Quantity-------------------
                        Row(
                          children: [
                            const Icon(
                              Icons.countertops_rounded,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
                                      return 'Please Enter Only Digits';
                                    }
                                  }
                                  return null;
                                },
                                controller: quantity,
                                decoration: InputDecoration(
                                  labelText: "${"Quantity"}",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                cursorColor: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: manufacturingDateValue,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please Select The Date';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(
                                  labelText: "${"Manufacture Date"}",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? _picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (_picked != null) {
                                    setState(() {
                                      manufacturingDateValue.text =
                                          _picked.toString().split(" ")[0];
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        //-----------------------Quantity section ends------------------
                        const SizedBox(
                          height: 10,
                        ),
                        //-----------------------Expiry Section-----------------------
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value == null)
                                    return 'Please Select The Date';
                                  if (value.isEmpty) {
                                    return 'Please Select The Date';
                                  }
                                  return null;
                                },
                                controller: expiryDateValue,
                                readOnly: true,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(
                                  labelText: "${"Expiry Date\*"}",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? _pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 0)),
                                    lastDate: DateTime(2100),
                                  );
                                  if (_pickedDate != null) {
                                    setState(() {
                                      expiryDateValue.text =
                                          _pickedDate.toString().split(" ")[0];
                                    });
                                  }
                                  bool isExecuted = false;
                                  expiryDateValue.addListener(() async {
                                    DateTime? newExpiryDate =
                                        DateTime.parse(expiryDateValue.text);
                                    // reminderDateFinder(
                                    //     selectedReminderDropDownValue,
                                    //     DateTime.parse(expiryDateValue.text));
                                    if (newExpiryDate != null) {
                                      // if (newExpiryDate
                                      //     .difference(DateTime.now())
                                      //     .inDays
                                      //     .isNegative) {
                                      //   AlertPastDate(context);
                                      // }
                                      // else {
                                      reminderDate.text = reminderDateFinder(
                                                  selectedReminderDropDownValue,
                                                  newExpiryDate)
                                              ?.toString()
                                              .split(" ")[0] ??
                                          '';
                                      // }
                                      if (!isExecuted) {
                                        if (DateTime.parse(reminderDate.text)
                                            .difference(DateTime.now())
                                            .inDays
                                            .isNegative) {
                                          AlertPastDate(context);
                                          reminderDate.text = "";
                                        }
                                        isExecuted = !isExecuted;
                                        expiryDateValue.removeListener(() {});
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: widget.isEnabled,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Please Select The Time";
                                  }
                                  return null;
                                },
                                controller: reminderTimeValue,
                                readOnly: true,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(
                                  labelText: "${"Reminder Time"}",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onTap: () async {
                                  TimeOfDay? _timePicked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  setState(() {
                                    reminderTimeValue.text =
                                        "${_timePicked!.hour}:${_timePicked.minute}";
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        //-----------------------------Expiry Section Ends-----------------
                        const SizedBox(
                          height: 10,
                        ),
                        //----------------------Reminder Section Starts---------------
                        Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == "Choose Reminder Date") {
                                      return "Please Select the value";
                                    }
                                    return null;
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  value: selectedReminderDropDownValue,
                                  menuMaxHeight: 300,
                                  dropdownColor: Colors.grey.shade300,
                                  isExpanded: true,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 22),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
                                  items: dropDownMenuReminderItemsList
                                      .map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      enabled: widget.isEnabled,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) async {
                                    if (newValue.toString() == "Never") {
                                      reminderDate.text = "";
                                    }
                                    if (newValue.toString() ==
                                        "On Specific Date") {
                                      DateTime? _datePicked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now()
                                            .subtract(Duration(days: 0)),
                                        lastDate: DateTime(2100),
                                      );
                                      if (_datePicked!
                                          .difference(DateTime.now())
                                          .inDays
                                          .isNegative) {
                                        AlertPastDate(context);
                                      } else {
                                        if (_datePicked != null) {
                                          setState(() {
                                            reminderDate.text = _datePicked
                                                .toString()
                                                .split(" ")[0];
                                            selectedReminderDropDownValue =
                                                newValue.toString();
                                          });
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        selectedReminderDropDownValue =
                                            newValue.toString();
                                        DateTime? reminderDateValue =
                                            reminderDateFinder(
                                                newValue.toString(),
                                                DateTime.parse(
                                                    expiryDateValue.text));
                                        if (reminderDateValue!
                                            .difference(DateTime.now())
                                            .inDays
                                            .isNegative) {
                                          AlertPastDate(context);
                                        } else {
                                          reminderDate.text =
                                              reminderDateValue != null
                                                  ? reminderDateValue
                                                      .toString()
                                                      .split(" ")[0]
                                                  : '';
                                        }
                                      });
                                    }
                                  }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: widget.isEnabled,
                                controller: reminderDate,
                                validator: (value) {
                                  if (selectedReminderDropDownValue ==
                                      "Never") {
                                    return null;
                                  }
                                  if (value!.isEmpty) {
                                    return 'Please Select The Date';
                                  }
                                  return null;
                                },
                                // readOnly: true,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(
                                  labelText: "${"Reminder Date"}",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //-----------------------Reminder Section Ends------------------------
                        Row(
                          children: [
                            const Icon(
                              Icons.event_note_rounded,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: Note,
                                enabled: widget.isEnabled,
                                decoration: InputDecoration(
                                  labelText: "Note",
                                  labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                cursorColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //-------------------Need To Buy Starts------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              size: 28,
                              color: Color.fromRGBO(0, 121, 106, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Need To Buy",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.grey.shade600),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Switch(
                                thumbIcon: bool.parse(isSwitchActive)
                                    ? const MaterialStatePropertyAll(
                                        Icon(Icons.check))
                                    : const MaterialStatePropertyAll(
                                        Icon(Icons.close)),
                                activeColor:
                                    const Color.fromRGBO(0, 151, 136, 1),
                                value: bool.parse(isSwitchActive),
                                onChanged: !widget.isEnabled
                                    ? null
                                    : (newvalue) {
                                        setState(() {
                                          isSwitchActive = newvalue.toString();
                                        });
                                      }),
                          ],
                        ),
                        //-------------------Need To Buy Ends------------------
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(0, 151, 136, 1),
                              ),
                              child: Text(
                                buttonText.toUpperCase(),
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: !widget.isEnabled
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: buttonText == "Add"
                                                ? const Text("Item Added")
                                                : const Text("Item Updated"),
                                          ),
                                        );
                                      }
                                      if (productName.text.isNotEmpty &&
                                          (selectedCategoryValueOfDropDownList
                                                  .isNotEmpty &&
                                              selectedCategoryValueOfDropDownList !=
                                                  'Choose Category') &&
                                          expiryDateValue.text.isNotEmpty &&
                                          (selectedReminderDropDownValue !=
                                                  'Choose Reminder Date' &&
                                              selectedReminderDropDownValue
                                                  .isNotEmpty) &&
                                          (reminderTimeValue.text.isNotEmpty)) {
                                        if (buttonText == "Add") {
                                          if (reminderDate.text.isNotEmpty) {
                                            NotificationHelper
                                                .scheduleReminderNotifications(
                                              productName: productName.text,
                                              reminderDate: DateTime.parse(
                                                  reminderDate.text),
                                              reminderTime:
                                                  reminderTimeValue.text,
                                              operation: buttonText,
                                              id: index,
                                            );
                                          }
                                          Provider.of<AddItemsProvider>(context,
                                                  listen: false)
                                              .addItem(
                                            ({
                                              'productName':
                                                  productName.text.trim(),
                                              'productPrice': price.text.isEmpty
                                                  ? null
                                                  : price.text.trim(),
                                              'category':
                                                  selectedCategoryValueOfDropDownList ==
                                                          'Choose Category'
                                                      ? null
                                                      : selectedCategoryValueOfDropDownList
                                                          .trim(),
                                              'productQuantity':
                                                  quantity.text.isEmpty
                                                      ? null
                                                      : quantity.text.trim(),
                                              'manufacturingDate':
                                                  manufacturingDateValue
                                                          .text.isEmpty
                                                      ? null
                                                      : manufacturingDateValue
                                                          .text
                                                          .trim(),
                                              'expiryDate':
                                                  expiryDateValue.text.trim(),
                                              'reminderTime':
                                                  reminderTimeValue.text.trim(),
                                              'choosedReminder':
                                                  selectedReminderDropDownValue ==
                                                              "Choose Reminder Date" ||
                                                          selectedReminderDropDownValue ==
                                                              "Never"
                                                      ? null
                                                      : selectedReminderDropDownValue
                                                          .trim(),
                                              'note': Note.text.isEmpty
                                                  ? null
                                                  : Note.text.trim(),
                                              'isNeeded': isSwitchActive
                                                  .toString()
                                                  .trim(),
                                              'dayLeftInExpiry': (DateTime.parse(
                                                              expiryDateValue
                                                                  .text)
                                                          .difference(
                                                              DateTime.now())
                                                          .inMinutes /
                                                      1440.0)
                                                  .ceil(),
                                              'dayLeftInExpiryPercent':
                                                  percentageDaysLeft(
                                                      expiryDateValue.text),
                                              "reminderDate":
                                                  reminderDate.text.isNotEmpty
                                                      ? reminderDate.text.trim()
                                                      : null,
                                              "isDeleted": "false"
                                            }),
                                          );
                                          Navigator.of(context).pop(true);
                                        } else {
                                          if (reminderDate.text.isNotEmpty) {
                                            NotificationHelper
                                                .scheduleReminderNotifications(
                                              productName: productName.text,
                                              reminderDate: DateTime.parse(
                                                  reminderDate.text),
                                              reminderTime:
                                                  reminderTimeValue.text,
                                              operation: "update",
                                              id: index,
                                            );
                                          }
                                          Provider.of<AddItemsProvider>(context,
                                                  listen: false)
                                              .updateItem(index, {
                                            'productName': productName.text,
                                            'productPrice': price.text.isEmpty
                                                ? null
                                                : price.text,
                                            'category':
                                                selectedCategoryValueOfDropDownList ==
                                                        'Choose Category'
                                                    ? null
                                                    : selectedCategoryValueOfDropDownList,
                                            'productQuantity':
                                                quantity.text.isEmpty
                                                    ? null
                                                    : quantity.text,
                                            'manufacturingDate':
                                                manufacturingDateValue
                                                        .text.isEmpty
                                                    ? null
                                                    : manufacturingDateValue
                                                        .text,
                                            'expiryDate': expiryDateValue.text,
                                            'reminderTime':
                                                reminderTimeValue.text,
                                            'choosedReminder':
                                                selectedReminderDropDownValue ==
                                                            "Choose Reminder Date" ||
                                                        selectedReminderDropDownValue ==
                                                            "Never"
                                                    ? null
                                                    : selectedReminderDropDownValue,
                                            'note': Note.text.isEmpty
                                                ? null
                                                : Note.text,
                                            'isNeeded': isSwitchActive
                                                .toString()
                                                .trim(),
                                            'dayLeftInExpiry': (DateTime.parse(
                                                            expiryDateValue
                                                                .text)
                                                        .difference(
                                                            DateTime.now())
                                                        .inMinutes /
                                                    1440.0)
                                                .ceil(),
                                            'dayLeftInExpiryPercent':
                                                percentageDaysLeft(
                                                    expiryDateValue.text),
                                            "reminderDate":
                                                reminderDate.text.isNotEmpty
                                                    ? reminderDate.text
                                                    : null,
                                            "isDeleted": "false"
                                          });
                                          Navigator.of(context).pop(true);
                                        }
                                      }
                                    }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> popAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          "Are you sure you want to exit?",
          style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "cancel",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              "discard",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> AlertPastDate(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Warning!",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w500),
            ),
            content: Text(
              "You can't select a reminder date that is in the past.",
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w400),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Ok",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ))
            ],
          );
        });
  }
}
