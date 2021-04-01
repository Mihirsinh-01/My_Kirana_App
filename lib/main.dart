import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './EditItems.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Kirana App',
      theme: ThemeData(
        primaryColor: Color(int.parse('0xff2e5cb8')),
        accentColor: Colors.blueAccent,
      ),
      home: GroceryList(),
    );
  }
}

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final _GroceryItems = <String>[];
  final _ItemPrice = <double>[];
  final _ImageLoc = <String>[];
  final _biggerFont =
      const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  File _image;
  String received = "hi";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    reload();
  }

  void reload() {
    getnames().then((val) => setState(() {
          _GroceryItems.clear();
          _GroceryItems.addAll(val);
//      _GroceryItems.clear();
        }));

    getprice().then((val) => setState(() {
          _ItemPrice.clear();
          _ItemPrice.addAll(val);
//      _ItemPrice.clear();
        }));
    getimage().then((val) => setState(() {
          _ImageLoc.clear();
          _ImageLoc.addAll(val);
        }));
  }

  Future<List<String>> getnames() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('ItemNames') ?? <String>[]);
  }

  Future<List<double>> getprice() async {
    final prefs = await SharedPreferences.getInstance();
    final _TempPrice = prefs.getStringList('ItemPrices') ?? <String>[];
    final _temp = <double>[];
    for (var i = 0; i < _TempPrice.length; i++) {
      _temp.add(double.parse(_TempPrice[i]));
    }
    return _temp;
  }

  Future<List<String>> getimage() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('ImagePath') ?? <String>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Kirana App'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _pushAdd),
          // removeAll   _pushAdd
        ],
      ),
      body: _GroceryItems.length > 0
          ? _buildItemList()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_business_rounded,
                    size: 200,
                  ),
                  Text(
                    "Use Top-Right button to Add Items",
                    style: _biggerFont,
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
//    print(image);
    setState(() {
      _image = image;
    });
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
//    print(image);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('ItemNames', <String>[]);
    prefs.setStringList('ImagePath', <String>[]);
    prefs.setStringList('ItemPrices', <String>[]);
  }

  void _pushAdd() async {
    final _formKey = GlobalKey<FormState>();
    final prefs = await SharedPreferences.getInstance();
    String name = "";
    double price = 0.0;

    // print(_GroceryItems.length);
    // print(_ImageLoc.length);
    // for(int i=0;i<_ImageLoc.length;i++){
    //   print(_GroceryItems[i]);
    //   print(_ImageLoc[i]);
    // }
    // print("done");

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            child: AppBar(
              title: Text("Add Items"),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.black54, Color.fromRGBO(0, 41, 102, 1)],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    child: ClipOval(
                      child: Image.asset(
                        './assets/images/default.jpg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () {
                          _image = null;
                          _showPicker(context);
                        },
                      ),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black54,
                    Color.fromRGBO(0, 41, 102, 1)
                    // Color.fromRGBO(0, 41, 102, 1),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        hintText: 'Enter Name',
                                        prefixIcon: const Icon(
                                          Icons.event_note_outlined,
                                          color: Colors.yellow,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1)),
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please Enter name';
                                        }
                                        name = text;
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 50),
                                    TextFormField(
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        hintText: 'Enter Price (Rs/Kg)',
                                        prefixIcon: const Icon(
                                          Icons.attach_money,
                                          color: Colors.yellow,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1)),
                                      ),
                                      validator: (text) {
                                        if (text == null ||
                                            text.isEmpty ||
                                            text[0] == '-') {
                                          return 'Price is InAppropriate';
                                        }
                                        try {
                                          price = double.parse(text);
                                        } catch (exception) {
                                          return 'Please enter proper Price';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                )),
                            FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    Map<String, Object> m = {
                                      "name": name,
                                      "price": price,
                                    };

                                    _GroceryItems.add(name);
                                    _ItemPrice.add(price);

                                    if (_image == null)
                                      _ImageLoc.add("NULL");
                                    else
                                      _ImageLoc.add(_image.path);

                                    _image = null;

                                    prefs.setStringList(
                                        'ItemNames', _GroceryItems);
                                    prefs.setStringList('ImagePath', _ImageLoc);
                                    final _TempPrice = <String>[];
                                    for (int i = 0;
                                        i < _ItemPrice.length;
                                        i++) {
                                      _TempPrice.add(_ItemPrice[i].toString());
                                    }
                                    prefs.setStringList(
                                        'ItemPrices', _TempPrice);
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 70,
                                  width: 200,
                                  child: Align(
                                    // alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      )),
                                ),
                              ),
                              // ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )),
          ],
        ),
      );
    }));
  }

  Future<String> _iconpressed(var i) async {
    received =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditItems('ItemNames', 'ItemPrices', 'ImagePath', i);
    }));

    return received;
  }

  Widget _buildItemList() {
    final allItems = <Widget>[];
    for (var i = 0; i < _GroceryItems.length; i++) {
      allItems.insert(
          0,
          Card(
            child: ListTile(
              title: Text(
                _GroceryItems[i],
                style: _biggerFont,
              ),
              subtitle: Text(_ItemPrice[i].toString() + " Rs/Kg"),
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 60,
                  minHeight: 60,
                  maxWidth: 60,
                  maxHeight: 60,
                ),
                // child: Image.asset('assets/images/default.jpg',
                //     fit: BoxFit
                //         .cover), //: Image.asset('assets/images/default.jpg',fit: BoxFit.cover)
//                Image.file(new File(_ImageLoc[i]), fit: BoxFit.cover), // 'assets/images/default.jpg'
                child: _ImageLoc[i] == 'NULL'
                    ? Image.asset('assets/images/default.jpg',
                        fit: BoxFit.cover)
                    : Image.file(new File(_ImageLoc[i]),
                        fit: BoxFit.cover), // 'assets/images/default.jpg'
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _iconpressed(i).then((val) => setState(() {
                        // print(val);
                        reload();
                      }));
                },
              ),
            ),
          ));
    }
    return ListView(
      children: allItems,
    );
  }

  Widget _buildRow(int ind) {
    return ListTile(
      title: Text(
        _GroceryItems[ind],
        style: _biggerFont,
      ),
      subtitle: Text(_ItemPrice[ind].toString()),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 60,
          minHeight: 60,
          maxWidth: 60,
          maxHeight: 60,
        ),
        child: Image.asset('assets/images/default.jpg', fit: BoxFit.cover),
      ),
    );
  }
}
