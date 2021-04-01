import 'package:flutter/material.dart';


void main() => runApp(NewItems());

class NewItems extends StatefulWidget {
  @override
  _NewItemsState createState() => _NewItemsState();
}

class _NewItemsState extends State<NewItems> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextFormField validator'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter text',
              ),
              textAlign: TextAlign.center,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Text is empty';
                }
                return null;
              },
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // TODO submit
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
