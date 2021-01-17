import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'loaders/color_loader_5.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'widgets/profile_menu.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  bool _isHidePassword = true;
  bool _validate = false;
  bool validateMobile = false;
  String name, phone, oldpassword, newpassword;

  @override
  void initState() {
    super.initState();
    print("profile screen");
    // DefaultCacheManager manager = new DefaultCacheManager();
    // manager.emptyCache();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    parsedDate = DateTime.parse(widget.user.datereg);

    return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          backgroundColor: Colors.white,
        ),
        body: Container(
            color: Colors.lightBlue[50],
            child: Column(children: <Widget>[
              SizedBox(height: 5),
              Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                height: screenHeight / 5,
                                width: screenWidth / 3.2,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  //border: Border.all(color: Colors.black),
                                ),
                                child: UserAccountsDrawerHeader(
                                  currentAccountPicture: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).platform ==
                                                TargetPlatform.android
                                            ? Colors.grey[300]
                                            : Colors.grey[300],
                                    child: Text(
                                      widget.user.name
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(fontSize: 40.0),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Container(
                            // color: Colors.red,
                            child: Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                columnWidths: {
                                  0: FlexColumnWidth(2.5),
                                  1: FlexColumnWidth(6.5),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 32,
                                          child: Text("Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 32,
                                        child: Text(widget.user.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 32,
                                          child: Text("Email",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 32,
                                        child: Text(widget.user.email,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 32,
                                          child: Text("Phone",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 32,
                                        child: Text(widget.user.phone,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 32,
                                          child: Text("Register",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 32,
                                        child: Text(f.format(parsedDate),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ]),
                                ]),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ProfileMenu(
                      text: "Change Name",
                      icon: "assets/icons/User Icon.svg",
                      press: changeName,
                    ),
                    ProfileMenu(
                      text: "Change Phone Number",
                      icon: "assets/icons/Bell.svg",
                      press: changePhone,
                    ),
                    ProfileMenu(
                      text: "Change Password",
                      icon: "assets/icons/Settings.svg",
                      press: changePassword,
                    ),
                    ProfileMenu(
                      text: "Log Out",
                      icon: "assets/icons/Question mark.svg",
                      press: _gotologinPage,
                    ),
                  ],
                ),
              ))
            ])));
  }

  void _takePicture() async {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    File _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    //print(_image.lengthSync());
    if (_image == null) {
      Toast.show("Please take image first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      http.post("https://lintatt.com/furniture/php/upload_image.php", body: {
        "encoded_string": base64Image,
        "email": widget.user.email,
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
        } else {
          Toast.show("Tidak berjaya", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void changeName() {
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your name?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: nameController,
                  validator: _validateName,
                  onSaved: (String val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(
                      Icons.person,
                      color: Colors.red[400],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post("https://lintatt.com/sportequipment/php/update_profile.php",
        body: {
          "email": widget.user.email,
          "name": rc.titleCase.toString(),
        }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.name = rc.titleCase;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePassword() {
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: passController,
                      validator: _validatePassword,
                      onSaved: (String val) {
                        oldpassword = val;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.red[400],
                        ),
                      )),
                  TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: pass2Controller,
                      validator: _validatePassword2,
                      onSaved: (String val) {
                        oldpassword = val;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.red[400],
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(color: Colors.red[400]),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String pass1, String pass2) {
    if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post("https://lintatt.com/furniture/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your phone?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: phoneController,
                  validator: _validatePhone,
                  onSaved: (String val) {
                    phone = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.red[400],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post("https://lintatt.com/sportequipment/php/update_profile.php",
        body: {
          "email": widget.user.email,
          "phone": phone,
        }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Log Out?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
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

  void _registerAccount() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Register new account?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
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

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.red[400]),
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

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  String _validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The name is required';
    } else if (value.length < 4) {
      return "At least 4 character";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'The password is required';
    }
    return null;
  }

  String _validatePassword2(String value) {
    if (value.isEmpty) {
      return 'The password is required';
    }
    return null;
  }

  String _validatePhone(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The phone No. is required';
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Phone Number";
    }
    return null;
  }
}
