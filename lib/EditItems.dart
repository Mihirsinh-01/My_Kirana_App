import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EditItems extends StatefulWidget {
  String name, price, image;
  int ind;

  EditItems(this.name, this.price, this.image, this.ind);

  @override
  _EditItemsState createState() => _EditItemsState(name, price, image, ind);
}

class _EditItemsState extends State<EditItems> {
  final _ItemName = <String>[];
  final _ItemPrice = <double>[];
  final _ItemLoc = <String>[];
  String name, price, image;
  int ind;
  double input = 0, output = 0;
  double newprice = 0.0;

  _EditItemsState(this.name, this.price, this.image, this.ind);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getnames().then((val) => setState(() {
          _ItemName.addAll(val);
//      _GroceryItems.clear();
        }));

    getprice().then((val) => setState(() {
          _ItemPrice.addAll(val);
//      _ItemPrice.clear();
        }));
    getimage().then((val) => setState(() {
          _ItemLoc.addAll(val);
        }));
  }

  Future<List<String>> getnames() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(name) ?? <String>[]);
  }

  Future<List<double>> getprice() async {
    final prefs = await SharedPreferences.getInstance();
    final _TempPrice = prefs.getStringList(price) ?? <String>[];
    final _temp = <double>[];
    for (var i = 0; i < _TempPrice.length; i++) {
      _temp.add(double.parse(_TempPrice[i]));
    }
    return _temp;
  }

  Future<List<String>> getimage() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(image) ?? <String>[]);
  }

  void _RemoveItem(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    _ItemPrice.removeAt(ind);
    _ItemName.removeAt(ind);
    _ItemLoc.removeAt(ind);

    final _temp = <String>[];
    for(int i=0;i<_ItemPrice.length;i++){
      _temp.add(_ItemPrice[i].toString());
    }
    prefs.setStringList(price, _temp);
    prefs.setStringList(name, _ItemName);
    prefs.setStringList(image, _ItemLoc);

    Navigator.pop(context);
  }

  void _UpdatePrice(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                      hintText: 'Enter New Price',
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty || text[0] == '-') {
                        return 'Invalid Price Entered';
                      }
                      try {
                        newprice = double.parse(text);
                      } catch (exception) {
                        return 'Please enter proper Price';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _ItemPrice[ind] = newprice;
                          final _temp = <String>[];
                          for (int i = 0; i < _ItemPrice.length; i++) {
                            _temp.add(_ItemPrice[i].toString());
                          }
                          prefs.setStringList(price, _temp);
                          Navigator.pop(context);
                        }
                      },
                    ))
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    print("hiii");
    print(_ItemLoc[0]);
    print(ind);
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: <Color>[
                      Colors.black54,
                      Color.fromRGBO(0, 41, 102, 1)
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context, 'done'),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                // child: Image.asset(
                                //   './assets/images/default.jpg',
                                //   height: 150,
                                //   width: 150,
                                //   fit: BoxFit.cover,
                                // ),
                                child: _ItemLoc[ind] == 'NULL' ? Image.asset(
                                  './assets/images/default.jpg',
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ): Image.file(new File(_ItemLoc[ind]), height: 150, width: 150, fit: BoxFit.cover,),
                              )),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 200,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _ItemName[ind],
                                // 'Hiiii',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Container(
                              width: 200,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _ItemPrice[ind].toString() + ' Rs/Kg',
                                // 'Price',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          // decoration: BoxDecoration(color: Colors.blue),
                          width: 205,
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(color: Colors.blue),

                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.update),
                                onPressed: () {
                                  _UpdatePrice(context);
                                },
                                color: Colors.white,
                                iconSize: 40,
                              ),
                              Text(
                                'Update Price',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 205,
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () => _RemoveItem(context),
                                color: Colors.white,
                                iconSize: 40,
                              ),
                              Text(
                                'Delete Item',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Conversion:',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 2.0,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  // decoration: BoxDecoration(color: Colors.blue),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(40, 10, 30, 0),
                          // decoration: BoxDecoration(color: Colors.white),
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              height: 60,
                              width: 100,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Nos',
                                  hintStyle: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                                validator: (text) {
                                  if (text == null ||
                                      text.isEmpty ||
                                      text[0] == '-') {
                                    return 'Please Enter Value';
                                  }
                                  try {
                                    input = double.parse(text);
                                  } catch (exception) {
                                    return 'Enter Proper Value';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )),
                      Icon(
                        Icons.east_outlined,
                        size: 50,
                      ),
                      Container(
                        width: 150,
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          // decoration: BoxDecoration(color: Colors.orange),
                          child: Text(
                            output.toString()+' Rs',
                            style: TextStyle(fontSize: 50),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 60,
                  width: 120,
                  child: RaisedButton(
                    child: Text(
                      'Convert',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          output = input * _ItemPrice[ind];
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
