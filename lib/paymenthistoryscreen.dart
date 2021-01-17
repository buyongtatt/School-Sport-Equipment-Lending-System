import 'dart:async';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sport_equipment/lending.dart';
import 'package:sport_equipment/lendingdetail.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'constants/constants.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  TextEditingController _paymentController = new TextEditingController();
  String titlecenter = "Loading lending history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lending History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Card(
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
                    margin: EdgeInsets.symmetric(vertical: appPadding / 2),
                    padding: EdgeInsets.symmetric(horizontal: appPadding),
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
                        controller: _paymentController,
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
                                _sortPaymentHistoryByDate(
                                    _paymentController.text)
                              },
                          elevation: 5,
                          child: Text(
                            "Search Payment",
                            style: TextStyle(color: Colors.black),
                          ))),
                ],
              ),
            ),
          ),
          Text(
            "Lending History",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _paymentdata == null
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
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                          child: InkWell(
                              onTap: () => loadLendingDetails(index),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "RM " +
                                                _paymentdata[index]['total'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Lending ID: \n" +
                                                    _paymentdata[index]
                                                        ['lendingid'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Divider(
                                                height: 2,
                                                thickness: 1,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                "Bill ID: " +
                                                    _paymentdata[index]
                                                        ['billid'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          _paymentdata[index]['date'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      })),
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://lintatt.com/sportequipment/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadLendingDetails(int index) {
    Lending lending = new Lending(
        billid: _paymentdata[index]['billid'],
        lendingid: _paymentdata[index]['lendingid'],
        total: _paymentdata[index]['total'],
        lendingdate: _paymentdata[index]['date']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LendingDetailScreen(
                  lending: lending,
                )));
  }

  void _sortPaymentHistoryByDate(String text) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://lintatt.com/sportequipment/php/load_paymenthistory.php";
      http
          .post(urlLoadJobs, body: {
            "search": text.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Payment not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              _paymentdata = extractdata["payment"];
              FocusScope.of(context).requestFocus(new FocusNode());

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
}
