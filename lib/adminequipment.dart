import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sport_equipment/login.dart';
import 'package:sport_equipment/mainscreen.dart';
import 'package:sport_equipment/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sport_equipment/constants/constants.dart';
import 'package:sport_equipment/equipmentdetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'models/equipment.dart';
import 'components/icon.dart';
import 'loaders/color_loader_2.dart';
import 'loaders/color_loader_5.dart';
import 'profilescreen.dart';
import 'paymenthistoryscreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'newequipment.dart';
import 'editequipment.dart';

class AdminEquipmentScreen extends StatefulWidget {
  final User user;

  const AdminEquipmentScreen({Key key, this.user}) : super(key: key);

  @override
  _AdminEquipmentScreenState createState() => _AdminEquipmentScreenState();
}

class _AdminEquipmentScreenState extends State<AdminEquipmentScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List equipmentdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "No product found";
  String server = "https://lintatt.com/sportequipment";
  var _tapPosition;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@sportequipment.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/m1.jpg'),
          AssetImage('assets/images/m2.jpg'),
          AssetImage('assets/images/m3.jpg'),
          AssetImage('assets/images/m4.jpg'),
          AssetImage('assets/images/m5.jpg'),
          AssetImage('assets/images/m6.jpg'),
          AssetImage('assets/images/m7.jpg'),
          AssetImage('assets/images/m8.jpg'),
        ],
        autoplay: true,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    if (equipmentdata == null) {
      return Scaffold(
          backgroundColor: Colors.lightBlue[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Admin Screen'),
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
                  "Loading Your Equipment",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
          )));
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.lightBlue[50],
          resizeToAvoidBottomPadding: false,
          drawer: mainDrawer(context),
          appBar: AppBar(
              title: Text('Admin Screen'),
              backgroundColor: Colors.white,
              actions: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.red[400],
                  ),
                  onPressed: () {
                    setState(() {
                      if (_visible) {
                        _visible = false;
                      } else {
                        _visible = true;
                      }
                    });
                  },
                ),
              ]),
          body: RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(101, 255, 218, 50),
            onRefresh: () async {
              await refreshList();
            },
            child: Container(
              color: Colors.lightBlue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  image_carousel,
                  Visibility(
                    visible: _visible,
                    child: Card(
                        color: Colors.white,
                        elevation: 10,
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Recent"),
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Text(
                                                "Recent",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Outdoor"),
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Text(
                                                "Outdoor",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Indoor"),
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Text(
                                                "Indoor",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                ],
                              ),
                            ))),
                  ),
                  Visibility(
                      visible: _visible,
                      child: Card(
                        color: Colors.lightBlue[50],
                        elevation: 5,
                        child: Container(
                          height: screenHeight / 12,
                          margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                  child: Container(
                                height: 30,
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
                                child: TextField(
                                    autofocus: false,
                                    controller: _prdController,
                                    decoration: InputDecoration(
                                        hintText: 'Search here...',
                                        hintStyle: TextStyle(
                                          color: darkGrey.withOpacity(0.6),
                                        ),
                                        icon: Icon(
                                          Icons.search_rounded,
                                          color: Colors.red[400],
                                        ),
                                        border: InputBorder.none)),
                              )),
                              Flexible(
                                  child: MaterialButton(
                                      color: Colors.white,
                                      onPressed: () => {
                                            _sortItembyName(_prdController.text)
                                          },
                                      elevation: 5,
                                      child: Text(
                                        "Search Equipment",
                                        style: TextStyle(color: Colors.black),
                                      )))
                            ],
                          ),
                        ),
                      )),
                  Text(curtype,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Flexible(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                              children:
                                  List.generate(equipmentdata.length, (index) {
                            return InkWell(
                                onTap: () => _showPopupMenu(index),
                                onTapDown: _storePosition,
                                child: Card(
                                    elevation: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Hero(
                                          tag: equipmentdata[index]['id']
                                              .toString(),
                                          child: Container(
                                            width: (screenWidth - 16) / 2,
                                            height: (screenWidth - 16) / 2,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "http://lintatt.com/sportequipment/equipmentimage/${equipmentdata[index]['id']}.jpg"),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            equipmentdata[index]['name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            'RM' +
                                                equipmentdata[index]['fee']
                                                    .toString() +
                                                '/hour',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )));
                          }))))
                ],
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: Colors.lightBlue[300],
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  backgroundColor: Colors.lightBlue[300],
                  child: Icon(
                    Icons.new_releases,
                  ),
                  label: "New Equipment",
                  labelStyle: TextStyle(color: Colors.white),
                  labelBackgroundColor: Colors.lightBlue[300],
                  onTap: addNewEquipment),
            ],
          ),
        ));
  }

  Future<void> addNewEquipment() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewEquipment()));
    _loadData();
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenHeight / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "http://lintatt.com/sportequipment/equipmentimage/${equipmentdata[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          equipmentdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          equipmentdata = extractdata["equipment"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.grey[300]
                      : Colors.grey[300],
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => ProfileScreen(
              //               user: widget.user,
              //             )))
            },
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.red[400],
              ),
              title: Text("Home Page"),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(
                                  user: widget.user,
                                ))),
                  }),
          ListTile(
              leading: Icon(
                Icons.shopping_basket,
                color: Colors.red[400],
              ),
              title: Text("Lending Cart"),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.red[400],
              ),
              title: Text("Lending History"),
              onTap: () => {Navigator.pop(context), gotoLending()}),
          ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.red[400],
              ),
              title: Text("User Profile"),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen(
                                  user: widget.user,
                                )))
                  }),
          ListTile(
              leading: Icon(
                logout,
                color: Colors.red[400],
              ),
              title: Text("Log Out"),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()))
                  }),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                    title: Text(
                      "Sport Equipment",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.edit,
                      color: Colors.red[400],
                    ),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdminEquipmentScreen(
                                        user: widget.user,
                                      )))
                        }),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://lintatt.com/sportequipment/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        setState(() {
          curtype = type;
          var extractdata = json.decode(res.body);
          equipmentdata = extractdata["equipment"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.dismiss();
        });
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://lintatt.com/sportequipment/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              equipmentdata = extractdata["equipment"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = prname;
              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "admin@sportequipment.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
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

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }

  gotoLending() async {
    if (widget.user.email == "admin@sportequipment.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PaymentHistoryScreen(
                    user: widget.user,
                  )));
    }
  }

  _onEquipmentDetail(int index) async {
    print(equipmentdata[index]['name']);
    Equipment equipment = new Equipment(
      id: equipmentdata[index]['id'],
      name: equipmentdata[index]['name'],
      fee: equipmentdata[index]['fee'],
      quantity: equipmentdata[index]['quantity'],
      type: equipmentdata[index]['type'],
      description: equipmentdata[index]['description'],
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditEquipment(
                  user: widget.user,
                  equipment: equipment,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
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
              onTap: () =>
                  {Navigator.of(context).pop(), _onEquipmentDetail(index)},
              child: Text(
                "Update Equipment",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteEquipmentDialog(index)},
              child: Text(
                "Delete Equipment",
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

  void _deleteEquipmentDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Equipment Id " + equipmentdata[index]['id'],
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
                _deleteEqupment(index);
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

  void _deleteEqupment(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting equipment...");
    pr.show();
    http.post("https://lintatt.com/sportequipment/php/delete_product.php",
        body: {
          "id": equipmentdata[index]['id'],
        }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }
}
