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

class NewEquipment extends StatefulWidget {
  @override
  _NewEquipmentState createState() => _NewEquipmentState();
}

class _NewEquipmentState extends State<NewEquipment> {
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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('New Equipment'),
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue[50],
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height: screenHeight / 3,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 5),
                Text("Click the above image to take picture of new equipment",
                    style: TextStyle(fontSize: 12.0, color: Colors.black)),
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
                                          child: TextFormField(
                                              cursorColor: Colors.red[400],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              controller: idEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: focus0,
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus1);
                                              },
                                              decoration: new InputDecoration(
                                                  hintText: 'ID',
                                                  hintStyle: TextStyle(
                                                    color: darkGrey
                                                        .withOpacity(0.6),
                                                  ),
                                                  border: InputBorder.none
                                                  //fillColor: Colors.green
                                                  )),
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
                                  child: Text('Insert New Equipment'),
                                  color: Colors.lightBlue[300],
                                  textColor: Colors.white,
                                  elevation: 5,
                                  onPressed: _insertNewProduct,
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

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 800,
      maxWidth: 800,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: "Cropping",
      ),
    );
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _onGetId() {
    scanBarcodeNormal();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        _scanBarcode = "click here to scan";
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void _insertNewProduct() {
    if (idEditingController.text.length < 3) {
      Toast.show("Please enter equipment id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_image == null) {
      Toast.show("Please take equipment photo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter equipment name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter equipment quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter lending fee per hour", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Equipment Id " + prnameEditingController.text,
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
                insertProduct();
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

  insertProduct() {
    double fee = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new equipment...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_product.php", body: {
      "id": idEditingController.text,
      "name": prnameEditingController.text,
      "fee": fee.toStringAsFixed(2),
      "quantity": qtyEditingController.text,
      "type": selectedType,
      "description": descriptionEditingController.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "found") {
        Toast.show("Equipment id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onGetId()},
              child: Text(
                "Scan Barcode",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), scanQR()},
              child: Text(
                "Scan QR Code",
                style: TextStyle(color: Colors.black),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _manCode()},
              child: Text(
                "Manual",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _manCode() {
    TextEditingController pridedtctrl = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Enter Equipment ID ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            height: 30,
            child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: pridedtctrl,
                cursorColor: Colors.red[400],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  fillColor: Colors.black,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                )),
          ),
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
                setState(() {
                  _scanBarcode = pridedtctrl.text;
                });
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
}
