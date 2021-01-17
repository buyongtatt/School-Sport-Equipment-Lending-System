import 'package:flutter/material.dart';
import 'package:sport_equipment/login.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name, email, phone, password;
  bool _validate = false;
  bool _isHidePassword = true;
  bool emailcheck = false;
  bool validateMobile = false;
  String phoneErrorMessage;
  double screenHeight;
  bool _isChecked = false;
  String selectedType;
  List<String> listType = [
    "Student",
    "Public",
  ];
  String urlRegister =
      "https://lintatt.com/sportequipment/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.lightBlue[50],
        body: Container(
            child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          )))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, 2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Form(
                          key: _formKey,
                          autovalidate: _validate,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(3.5),
                                  decoration: BoxDecoration(),
                                  child: TextFormField(
                                    controller: _nameEditingController,
                                    keyboardType: TextInputType.text,
                                    validator: _validateName,
                                    onSaved: (String val) {
                                      name = val;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Name",
                                      icon: Icon(Icons.person),
                                    ),
                                  )),
                              Container(
                                  padding: EdgeInsets.all(3.5),
                                  decoration: BoxDecoration(),
                                  child: TextFormField(
                                    controller: _emailEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    onSaved: (String val) {
                                      email = val;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Email",
                                      icon: Icon(Icons.email),
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.all(3.5),
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  obscureText: _isHidePassword,
                                  controller: _passEditingController,
                                  validator: _validatePassword,
                                  onSaved: (String val) {
                                    password = val;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Password",
                                      icon: Icon(Icons.lock),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            _togglePasswordVisibility();
                                          },
                                          child: Icon(
                                            _isHidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: _isHidePassword
                                                ? Colors.grey
                                                : Colors.green,
                                          ))),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(3.5),
                                  decoration: BoxDecoration(),
                                  child: TextFormField(
                                    controller: _phoneditingController,
                                    keyboardType: TextInputType.phone,
                                    validator: _validatePhone,
                                    onSaved: (String val) {
                                      phone = val;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Phone",
                                      icon: Icon(Icons.phone),
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.all(3.5),
                                decoration: BoxDecoration(),
                                child: DropdownButton(
                                  //sorting dropdownoption
                                  hint: Text(
                                    'User Type',
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
                                  items: listType.map((selectedType) {
                                    return DropdownMenuItem(
                                      child: new Text(selectedType,
                                          style:
                                              TextStyle(color: Colors.black)),
                                      value: selectedType,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        GestureDetector(
                          onTap: _showEULA,
                          child: Text('I Agree to Terms  ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 115,
                      height: 50,
                      child: Text('Register'),
                      color: Colors.grey[300],
                      textColor: Colors.black,
                      elevation: 10,
                      onPressed: _onRegister,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already register? ",
                            style: TextStyle(fontSize: 16.0)),
                        GestureDetector(
                          onTap: _loginScreen,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        )),
      ),
    );
  }

  void _onRegister() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register Confirmation"),
          content: new Container(
            height: screenHeight / 10,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                            text:
                                "Are you sure wants to register a new account?" //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text(
                  "Yes, Continue",
                  style: TextStyle(
                    color: Colors.red[400],
                    //fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _register();
                }),
            new FlatButton(
              child: new Text("No, Cancel",
                  style: TextStyle(
                    color: Colors.red[400],
                    //fontWeight: FontWeight.w500,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            )
          ],
        );
      },
    );
  }

  void _register() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String password = _passEditingController.text;

    String phone = _phoneditingController.text;

    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (selectedType != "Student" && selectedType != "Public") {
      Toast.show("Please select a user type", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "usertype": selectedType,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("Name $name");
        print("Email $email");
        print("Phone $phone");
        print("Password $password");
      } else {
        setState(() {
          _validate = true;
        });
      }

      //savepref(value);
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

  String _validateEmail(String value) {
    emailcheck = EmailValidator.validate(value);
    if (value.isEmpty) {
      return 'The email is required';
    } else if (emailcheck == false) {
      return "Invalid Email";
    } else {
      return null;
    }
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

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'The password is required';
    }
    return null;
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of MyLendSport"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                """This End-User License Agreement ("EULA") is a legal agreement between you and School Sport Equipment Lending System. Our EULA was created by EULA Template for MyLendSport.

This EULA agreement governs your acquisition and use of our MyLendSport software ("Software") directly from School Sport Equipment Lending System or indirectly through a School Sport Equipment Lending System authorized reseller or distributor (a "Reseller"). Our Privacy Policy was created by the Privacy Policy Generator.

Please read this EULA agreement carefully before completing the installation process and using the MyLendSport software. It provides a license to use the MyLendSport software and contains warranty information and liability disclaimers.

If you register for a free trial of the MyLendSport software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the MyLendSport software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

This EULA agreement shall apply only to the Software supplied by School Sport Equipment Lending System herewith regardless of whether other software is referred to or described herein. The terms also apply to any School Sport Equipment Lending System updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.

License Grant
School Sport Equipment Lending System hereby grants you a personal, non-transferable, non-exclusive licence to use the MyLendSport software on your devices in accordance with the terms of this EULA agreement.

You are permitted to load the MyLendSport software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the MyLendSport software.

You are not permitted to:

Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
Allow any third party to use the Software on behalf of or for the benefit of any third party
Use the Software in any way which breaches any applicable local, national or international law
use the Software for any purpose that School Sport Equipment Lending System considers is a breach of this EULA agreement
Intellectual Property and Ownership
School Sport Equipment Lending System shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of School Sport Equipment Lending System.

School Sport Equipment Lending System reserves the right to grant licences to use the Software to third parties.

Termination
This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to School Sport Equipment Lending System.

It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.

Governing Law
This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of my."""
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.red[400],
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
