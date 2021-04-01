import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItems extends StatefulWidget {
  @override
  AddItemsState createState() => AddItemsState();
}

class AddItemsState extends State<AddItems> {
  final _formKey = GlobalKey<FormState>();
  static String name = "";
  static double price = 0.0;
  static File _image;
  Map<String, Object> m1;

  Map<String,Object> getvalues(){
    return m1;
  }

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    print(image);
    setState(() {
      _image = image;
    });
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    print(image);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
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
                        decoration: InputDecoration(
                          hintText: 'Enter Price (Rs/Kg)',
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Price is empty';
                          }
                          try {
                            price = double.parse(text);
                          } catch (exception) {
                            return 'Please enter proper Price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              Map<String, Object> m = {
                                "name": name,
                                "price": price,
                                "imgpath": _image.toString(),
                              };

                              m1 = m;

//                            _GroceryItems.add(name);
//                            _ItemPrice.add(price);
//                            prefs.setStringList('ItemNames', _GroceryItems);
//                            final _TempPrice = <String>[];
//                            for (int i = 0; i < _ItemPrice.length; i++) {
//                              _TempPrice.add(_ItemPrice[i].toString());
//                            }
//                            prefs.setStringList('ItemPrices', _TempPrice);
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text('Submit'),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
