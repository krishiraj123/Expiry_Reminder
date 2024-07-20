import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:expiry_reminder/api/notifications.dart';
import 'package:expiry_reminder/components/add_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'add_items_provider.dart';

class CustomSwipeCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic>? item;

  const CustomSwipeCard({super.key, this.index = -1, this.item});

  @override
  State<CustomSwipeCard> createState() => _CustomSwipeCardState();
}

class _CustomSwipeCardState extends State<CustomSwipeCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.red,
      height: 125,
      child: Card(
        // elevation: 3,
        margin: const EdgeInsets.only(top: 15),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddItemPage(
                  productNameValue: widget.item!["productName"],
                  priceValue: widget.item!["productPrice"],
                  categoryValue: widget.item!["category"],
                  quantityValue: widget.item!["productQuantity"],
                  manufactureDateValue: widget.item!["manufacturingDate"],
                  expiryDateValue: widget.item!["expiryDate"],
                  reminderTimeValue: widget.item!["reminderTime"],
                  reminderDateValue: widget.item!["choosedReminder"],
                  note: widget.item!["note"],
                  needToBuy: widget.item!["isNeeded"].toString(),
                  buttonTextValue: "Update",
                  indexValue: widget.item!["PID"],
                  reminderDate: widget.item!["reminderDate"],
                  isEnabled: false,
                ),
              ),
            ).then((value) {
              setState(() {});
            });
            setState(() {});
          },
          child: Dismissible(
              key: ValueKey<int>(widget.index),
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
                  color: widget.item!["isDeleted"] == "true"
                      ? Colors.yellow.shade200
                      : Colors.green.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerRight,
                child: widget.item!["isDeleted"] == "true"
                    ? Icon(Icons.restore)
                    : Icon(Icons.edit),
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
                            textScaler: TextScaler.linear(1),
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  widget.item!["isDeleted"] == "true"
                                      ? Provider.of<AddItemsProvider>(context,
                                              listen: false)
                                          .removeItem(widget.item!["PID"])
                                      : Provider.of<AddItemsProvider>(context,
                                              listen: false)
                                          .deleteItem(widget.item!["PID"]);
                                  // .removeItem(widget.item!["PID"]);
                                  NotificationHelper.cancelNotification(
                                      widget.item!["PID"]);
                                  Navigator.of(context).pop();

                                  widget.item!["isDeleted"] == "true"
                                      ? AnimatedSnackBar.material(
                                              "Item Deleted Successfully",
                                              type: AnimatedSnackBarType.error,
                                              mobileSnackBarPosition:
                                                  MobileSnackBarPosition.bottom,
                                              desktopSnackBarPosition:
                                                  DesktopSnackBarPosition
                                                      .bottomRight,
                                              animationDuration:
                                                  Duration(seconds: 1))
                                          .show(context)
                                      : AnimatedSnackBar.material(
                                              "Item removed Successfully",
                                              type:
                                                  AnimatedSnackBarType.warning,
                                              mobileSnackBarPosition:
                                                  MobileSnackBarPosition.bottom,
                                              desktopSnackBarPosition:
                                                  DesktopSnackBarPosition
                                                      .bottomRight,
                                              animationDuration:
                                                  Duration(seconds: 1))
                                          .show(context);
                                  setState(() {});
                                },
                                child: Text("Ok",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold))),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel",
                                    textScaler: TextScaler.linear(1),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold))),
                          ],
                        );
                      });
                }
                if (direction == DismissDirection.endToStart) {
                  widget.item!["isDeleted"] == "true"
                      ? await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                "Are you sure you wish to restore this item?",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                textScaler: TextScaler.linear(1),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Provider.of<AddItemsProvider>(context,
                                              listen: false)
                                          .restoreItem(widget.item!["PID"]);
                                      Navigator.of(context).pop();
                                      AnimatedSnackBar.material(
                                              "Item restored Successfully",
                                              type: AnimatedSnackBarType.info,
                                              mobileSnackBarPosition:
                                                  MobileSnackBarPosition.bottom,
                                              desktopSnackBarPosition:
                                                  DesktopSnackBarPosition
                                                      .bottomRight,
                                              animationDuration:
                                                  Duration(seconds: 1))
                                          .show(context);
                                      setState(() {});
                                    },
                                    child: Text("Ok",
                                        textScaler: TextScaler.linear(1),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold))),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel",
                                        textScaler: TextScaler.linear(1),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold))),
                              ],
                            );
                          })
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddItemPage(
                              productNameValue: widget.item!["productName"],
                              priceValue: widget.item!["productPrice"],
                              categoryValue: widget.item!["category"],
                              quantityValue: widget.item!["productQuantity"],
                              manufactureDateValue:
                                  widget.item!["manufacturingDate"],
                              expiryDateValue: widget.item!["expiryDate"],
                              reminderTimeValue: widget.item!["reminderTime"],
                              reminderDateValue:
                                  widget.item!["choosedReminder"],
                              note: widget.item!["note"],
                              needToBuy: widget.item!["isNeeded"].toString(),
                              buttonTextValue: "Update",
                              indexValue: widget.item!["PID"],
                              reminderDate: widget.item!["reminderDate"],
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                  setState(() {});
                }
                return false;
              },
              child: Container(
                alignment: Alignment.topLeft,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.item!['dayLeftInExpiry'] <= 0
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
                      percent: widget.item!['dayLeftInExpiryPercent'],
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.item!["dayLeftInExpiry"] < 0 ? widget.item!["dayLeftInExpiry"] * -1 : widget.item!["dayLeftInExpiry"]}",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                          Text(
                              "Days ${widget.item!['dayLeftInExpiry'] < 0 ? 'Ago' : 'Left'}",
                              textScaler: TextScaler.linear(1),
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey.shade700)),
                        ],
                      ),
                      backgroundColor: Colors.green.shade100,
                      backgroundWidth: 3,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item!["productName"]
                                  .toString()
                                  .toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              textScaler: TextScaler.linear(1),
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade700),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Exp Date: ${widget.item!["expiryDate"]}",
                              overflow: TextOverflow.ellipsis,
                              textScaler: TextScaler.linear(1),
                              style: GoogleFonts.lato(
                                  fontSize: 15, letterSpacing: 1.4),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (widget.item!["note"] != null)
                              Text(
                                widget.item!["note"],
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
      ),
    );
  }
}
