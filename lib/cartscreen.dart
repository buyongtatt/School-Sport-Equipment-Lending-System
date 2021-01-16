import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loaders/color_loader_2.dart';
import 'loaders/color_loader_5.dart';
import 'package:sport_equipment/theme/colors.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String server = "https://lintatt.com/sportequipment";
  List cartData;
  double screenHeight, screenWidth;
  double _totalfee = 0.0;

  String label;
  double amountpayable;
  @override
  void initState() {
    _loadCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (cartData == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('My Cart'),
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ColorLoader2(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading Your Cart",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
          )));
    } else {
      return Scaffold(
        bottomSheet: Container(
            color: primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    "Total Amount : RM" + amountpayable.toStringAsFixed(2) ??
                        "0.0",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 100,
                  height: 80,
                  child: Text("Make Payment"),
                  color: Colors.white,
                  textColor: Colors.black,
                  elevation: 10,
                  // onPressed: makePaymentDialog,
                ),
              ],
            )),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('My Cart'),
          actions: <Widget>[
            IconButton(
              color: Colors.red[400],
              icon: Icon(MdiIcons.deleteEmpty),
              onPressed: () {
                deleteAll();
              },
            ),
          ],
        ),
        body: Container(
          child: ListView.builder(
              itemCount: cartData == null ? 1 : cartData.length,
              itemBuilder: (context, index) {
                if (index == cartData.length) {
                  return Container(
                      height: screenHeight / 1.6,
                      width: screenWidth / 2.5,
                      child: InkWell(
                          onLongPress: () => {print("Delete")},
                          child: Card(
                              color: Colors.white,
                              elevation: 5,
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: Row(children: <Widget>[
                                  Container(
                                    // color: Colors.red,
                                    width: screenWidth / 2,
                                    // height: screenHeight / 3,
                                  ),
                                ]))
                              ]))));
                }

                index -= 0;

                return Card(
                  child: ListTile(
                      onTap: () => {_deleteCart(index)},
                      leading: new CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            "http://lintatt.com/sportequipment/equipmentimage/${cartData[index]['id']}.jpg",
                        placeholder: (context, url) => new ColorLoader5(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                        width: 80.0,
                        height: 80.0,
                      ),
                      title: new Text(
                        cartData[index]['name'],
                      ),
                      subtitle: new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text("Fee: "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  "RM" + cartData[index]['fee'] + '/hour',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          new Row(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text("Hour: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(
                                cartData[index]['hour'],
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ]),
                          new Container(
                            alignment: Alignment.topLeft,
                            child: new Text(
                              "RM" + cartData[index]['yourfee'],
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          )
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          children: <Widget>[
                            new FlatButton(
                              child: Icon(
                                Icons.arrow_drop_up,
                                size: 100.0,
                              ),
                              onPressed: () => {
                                _updateCart(index, "add"),
                              },
                            ),
                            new Text(
                              cartData[index]['cquantity'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 60,
                              ),
                            ),
                            new FlatButton(
                              child: Icon(Icons.arrow_drop_down, size: 100.0),
                              onPressed: () => {_updateCart(index, "remove")},
                            ),
                          ],
                        ),
                      )),
                );
              }),
        ),
      );
    }
  }

  void _loadCart() {
    _totalfee = 0.0;
    amountpayable = 0.0;

    String urlLoadJobs = server + "/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _totalfee = double.parse(cartData[i]['yourfee']) + _totalfee;
        }

        if (widget.user.usertype == 'Student') {
          amountpayable = 0.00;
        } else if (widget.user.usertype == 'Public') {
          amountpayable = _totalfee;
        }

        print(amountpayable);
      });
    }).catchError((err) {
      print(err);
    });
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        quantity++;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs =
        "https://lintatt.com/sportequipment/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "id": cartData[index]['id'],
      "quantity": quantity.toString(),
      "hour": cartData[index]['hour'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://lintatt.com/sportequipment/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "id": cartData[index]['id'],
                      "hour": cartData[index]['hour'],
                    }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
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
    );
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
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
    );
  }
}
