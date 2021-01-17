import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_equipment/lending.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'constants/constants.dart';
import 'loaders/color_loader_5.dart';

class LendingDetailScreen extends StatefulWidget {
  final Lending lending;

  const LendingDetailScreen({Key key, this.lending}) : super(key: key);
  @override
  _LendingDetailScreenState createState() => _LendingDetailScreenState();
}

class _LendingDetailScreenState extends State<LendingDetailScreen> {
  List _lendingdetails;
  String titlecenter = "Loading lending details...";
  double screenHeight, screenWidth;
  String server = "https://lintatt.com/sportequipment";

  @override
  void initState() {
    super.initState();
    _loadLendingDetails();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lending Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Lending Details",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _lendingdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _lendingdetails == null ? 0 : _lendingdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                child: Container(
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
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 0,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/equipmentimage/${_lendingdetails[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new ColorLoader5(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _lendingdetails[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "Lent Quantity: " +
                                                        _lendingdetails[index]
                                                            ['cquantity'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "Lent Hour(s): " +
                                                        _lendingdetails[index]
                                                            ['hour'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            child: Text(
                                              "RM" +
                                                  _lendingdetails[index]
                                                      ['fee'] +
                                                  "/hour",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            flex: 3,
                                          ),
                                        ],
                                      ),
                                    ))));
                      }))
        ]),
      ),
    );
  }

  _loadLendingDetails() async {
    String urlLoadJobs =
        "https://lintatt.com/sportequipment/php/load_carthistory.php";
    print(widget.lending.lendingid);
    await http.post(urlLoadJobs, body: {
      "lendingid": widget.lending.lendingid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _lendingdetails = null;
          titlecenter = "No Previous Lending";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _lendingdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
