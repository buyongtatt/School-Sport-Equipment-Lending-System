import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sport_equipment/theme/colors.dart';
import 'models/equipment.dart';
import 'user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:sport_equipment/loaders/color_loader_5.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EquipmentDetail extends StatefulWidget {
  final Equipment equipment;
  final User user;

  const EquipmentDetail({Key key, this.equipment, this.user}) : super(key: key);
  @override
  _EquipmentDetailState createState() => _EquipmentDetailState();
}

class _EquipmentDetailState extends State<EquipmentDetail> {
  int quantity = 1;
  int hour = 1;
  int activeSize = 0;
  int activeColor = 0;
  String activeImg = '';
  int qty = 1;
  String cartquantity = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomSheet: getBottom(),
      backgroundColor: Colors.lightBlue[50],
    );
  }

  Widget getBottom() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: size.width,
      child: FlatButton(
          color: primary,
          onPressed: () => _addtocartdialog(widget.equipment.id),
          child: Text(
            "ADD TO CART",
            style: TextStyle(fontSize: 18, color: white),
          )),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back_ios)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 2,
              child: Hero(
                tag: widget.equipment.id.toString(),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://lintatt.com/sportequipment/equipmentimage/${widget.equipment.id}.jpg"),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name :",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.equipment.name,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Description :",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.equipment.description,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Fee :",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      Text(
                        'RM' + widget.equipment.fee + "/hour",
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.red,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Type :",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.equipment.type,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Quantity :",
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.equipment.quantity,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _addtocartdialog(String id) {
    if (widget.user.email == "admin@sportequipment.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + widget.equipment.name + " to Cart?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of equipment",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.red[400],
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(widget.equipment.quantity))) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Select time duration for lending in hour(s)",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (hour > 1) {
                                  hour--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.red[400],
                            ),
                          ),
                          Text(
                            hour.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (hour < 3) {
                                  hour++;
                                } else {
                                  Toast.show("Do not exceed 3 hours", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(widget.equipment.id, this.hour);
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
            );
          });
        });
  }

  void _addtoCart(String index, int hour) {
    try {
      int cquantity = int.parse(widget.equipment.quantity);
      print(cquantity);
      print(widget.equipment.id);
      print(widget.user.email);
      if (cquantity > 0) {
        ColorLoader5();
        String urlLoadJobs =
            "https://lintatt.com/sportequipment/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "id": widget.equipment.id,
          "quantity": quantity.toString(),
          "hour": hour.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
