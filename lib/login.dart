import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_equipment/mainscreen.dart';
import 'package:sport_equipment/register.dart';

import 'package:sport_equipment/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:sport_equipment/loaders/color_loader_4.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidePassword = true;
  bool emailcheck = false;
  bool _passwordShow = true;
  bool autovalidate = false;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();
  String urlLogin = "https://lintatt.com/sportequipment/php/login_user.php";
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyForResetEmail = GlobalKey<FormState>();
  final _formKeyForResetPassword = GlobalKey<FormState>();
  String email, password;

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.lightBlue[50],
            body: Container(
                child: Column(
              children: <Widget>[
                Container(
                  height: 300,
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
                                  "Login",
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
                    padding: EdgeInsets.all(10.0),
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
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(),
                                      child: TextFormField(
                                        controller: _emailEditingController,
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
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(),
                                      child: TextFormField(
                                        controller: _passEditingController,
                                        validator: _validatePassword,
                                        onSaved: (String val) {
                                          email = val;
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
                                        obscureText: _isHidePassword,
                                      )),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: rememberMe,
                              onChanged: (bool value) {
                                _onRememberMeChanged(value);
                              },
                            ),
                            Text('Remember Me ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 115,
                          height: 50,
                          child: Text('Login'),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          elevation: 10,
                          onPressed: this._userLogin,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? ",
                                style: TextStyle(fontSize: 16.0)),
                            GestureDetector(
                              onTap: _registerUser,
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Forgot your password ",
                                style: TextStyle(fontSize: 16.0)),
                            GestureDetector(
                              onTap: _forgotPassword,
                              child: Text(
                                "Reset Password",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            )),
          ),
        ));
  }

  void _forgotPassword() {
    TextEditingController emailController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                ),
                Form(
                    key: _formKeyForResetEmail,
                    child: TextFormField(
                        controller: emailController,
                        validator: _validateEmail,
                        onSaved: (String val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                        )))
              ],
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
                  if (_formKeyForResetEmail.currentState.validate()) {
                    _passwordShow = false;
                    emailForgotController.text = emailController.text;

                    _enterResetPass();
                  }
                }),
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

  _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text("New password"),
              content: new Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter your new password:",
                      ),
                    ),
                    Form(
                        key: _formKeyForResetPassword,
                        child: TextFormField(
                            controller: passController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isHidePassword = !_isHidePassword;
                                  });
                                },
                                child: Icon(
                                  _isHidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _isHidePassword
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                              ),
                            ),
                            obscureText: _isHidePassword,
                            validator: _validatePassword,
                            onSaved: (String value) {
                              password = value;
                            }))
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Yes"),
                    onPressed: () {
                      if (_formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPass();
                      }
                    }),
                new FlatButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  _resetPass() {
    String email = emailForgotController.text;
    String password = passResetController.text;

    final form = _formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://lintatt.com/sportequipment/php/reset_password.php",
          body: {
            "email": email,
            "password": password,
          }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop(false);
          Navigator.of(context).pop(false);
          Toast.show("Reset password success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("Reset password failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        autovalidate = true;
      });
    }
  }

  void _userLogin() async {
    try {
      ColorLoader4();
      String _email = _emailEditingController.text;
      String _password = _passEditingController.text;

      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        var string = res.body;
        print(res.body);
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              usertype: userdata[4],
              verify: userdata[5],
              datereg: userdata[6],
              quantity: userdata[7]);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
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

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'The password is required';
    }
    return null;
  }
}
