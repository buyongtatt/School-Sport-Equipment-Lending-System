import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'constants/constants.dart';
import 'user.dart';
import 'models/equipment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loaders/color_loader_5.dart';

class EditEquipment extends StatefulWidget {
  final User user;
  final Equipment equipment;

  const EditEquipment({Key key, this.user, this.equipment}) : super(key: key);
  @override
  _EditEquipmentState createState() => _EditEquipmentState();
}

class _EditEquipmentState extends State<EditEquipment> {
  String server = "https://lintatt.com/sportequipment";
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;
  String _scanBarcode = 'click here to scan';
  String pathAsset = 'assets/images/capture.png';
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController weigthEditingController = new TextEditingController();
  TextEditingController idEditingController = new TextEditingController();
  TextEditingController descriptionEditingController =
      new TextEditingController();
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  String selectedType;
  List<String> listType = [
    "Indoor",
    "Outdoor",
  ];
  @override
  void initState() {
    super.initState();

    prnameEditingController.text = widget.equipment.name;
    priceEditingController.text = widget.equipment.fee;
    qtyEditingController.text = widget.equipment.quantity;
    typeEditingController.text = widget.equipment.type;
    descriptionEditingController.text = widget.equipment.description;
    selectedType = widget.equipment.type;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Equipment'),
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue[50],
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                Container(
                  height: screenHeight / 3,
                  width: screenWidth / 1.5,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "http://lintatt.com/sportequipment/equipmentimage/${widget.equipment.id}.jpg",
                    placeholder: (context, url) => new ColorLoader5(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    color: Colors.white,
                    width: screenWidth / 1.2,
                    //height: screenHeight / 2,
                    child: Card(
                        color: Colors.white,
                        elevation: 6,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Equipment ID",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ))),
                                        ),
                                        TableCell(
                                            child: Container(
                                          height: 30,
                                          margin: EdgeInsets.symmetric(
                                              vertical: appPadding / 2),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: appPadding),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      darkGrey.withOpacity(0.4),
                                                  offset: Offset(10, 10),
                                                  blurRadius: 10,
                                                )
                                              ]),
                                          child: Text(
                                            " " + widget.equipment.id,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Equipment Name",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            height: 30,
                                            margin: EdgeInsets.symmetric(
                                                vertical: appPadding / 2),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: appPadding),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: darkGrey
                                                        .withOpacity(0.4),
                                                    offset: Offset(10, 10),
                                                    blurRadius: 10,
                                                  )
                                                ]),
                                            child: TextFormField(
                                                cursorColor: Colors.red[400],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    prnameEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus1,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus2);
                                                },
                                                decoration: new InputDecoration(
                                                    hintText: 'Name',
                                                    hintStyle: TextStyle(
                                                      color: darkGrey
                                                          .withOpacity(0.6),
                                                    ),
                                                    border: InputBorder.none

                                                    //fillColor: Colors.green
                                                    )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Fee (RM/hour)",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            height: 30,
                                            margin: EdgeInsets.symmetric(
                                                vertical: appPadding / 2),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: appPadding),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: darkGrey
                                                        .withOpacity(0.4),
                                                    offset: Offset(10, 10),
                                                    blurRadius: 10,
                                                  )
                                                ]),
                                            child: TextFormField(
                                                cursorColor: Colors.red[400],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    priceEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus2,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus3);
                                                },
                                                decoration: new InputDecoration(
                                                    hintText: 'Fee',
                                                    hintStyle: TextStyle(
                                                      color: darkGrey
                                                          .withOpacity(0.6),
                                                    ),
                                                    border: InputBorder.none
                                                    //fillColor: Colors.green
                                                    )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Quantity",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            height: 30,
                                            margin: EdgeInsets.symmetric(
                                                vertical: appPadding / 2),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: appPadding),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: darkGrey
                                                        .withOpacity(0.4),
                                                    offset: Offset(10, 10),
                                                    blurRadius: 10,
                                                  )
                                                ]),
                                            child: TextFormField(
                                                cursorColor: Colors.red[400],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    qtyEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus3,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus4);
                                                },
                                                decoration: new InputDecoration(
                                                    hintText: 'Quantity',
                                                    hintStyle: TextStyle(
                                                      color: darkGrey
                                                          .withOpacity(0.6),
                                                    ),
                                                    border: InputBorder.none
                                                    //fillColor: Colors.green
                                                    )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Type",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'Type',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ), // Not necessary for Option 1
                                                value: selectedType,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedType = newValue;
                                                    print(selectedType);
                                                  });
                                                },
                                                items: listType
                                                    .map((selectedType) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedType,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    value: selectedType,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ]),
                                Column(children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Equipment Description",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ))),
                                  Container(
                                    height: 100,
                                    margin: EdgeInsets.symmetric(
                                        vertical: appPadding / 2),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: appPadding),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: darkGrey.withOpacity(0.4),
                                            offset: Offset(10, 10),
                                            blurRadius: 10,
                                          )
                                        ]),
                                    child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        cursorColor: Colors.red[400],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller:
                                            descriptionEditingController,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.next,
                                        focusNode: focus4,
                                        decoration: new InputDecoration(
                                            hintText: 'Description',
                                            hintStyle: TextStyle(
                                              color: darkGrey.withOpacity(0.6),
                                            ),
                                            border: InputBorder.none

                                            //fillColor: Colors.green
                                            )),
                                  ),
                                ]),
                                SizedBox(height: 3),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  minWidth: screenWidth / 1.5,
                                  height: 40,
                                  child: Text('Update Equipment'),
                                  color: Colors.lightBlue[300],
                                  textColor: Colors.white,
                                  elevation: 5,
                                  onPressed: () => updateEquipmentDialog(),
                                ),
                              ],
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateEquipmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Equipment ID " + widget.equipment.id,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateEquipment();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.red[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateEquipment() {
    if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    double fee = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating product...");
    pr.show();

    http.post("https://lintatt.com/sportequipment/php/update_product.php",
        body: {
          "id": widget.equipment.id,
          "name": prnameEditingController.text,
          "quantity": qtyEditingController.text,
          "fee": fee.toStringAsFixed(2),
          "type": selectedType,
          "description": descriptionEditingController.text,
        }).then((res) {
      print(res.body);

      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Update failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }
}
