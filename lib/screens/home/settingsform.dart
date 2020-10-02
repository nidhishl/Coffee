import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> sugar = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          //snapshot refers to the data coming down the stream (belongs to flutter)

          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: TextInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: TextInputDecoration,
                    value: _currentSugar ?? userData.sugar,
                    items: sugar.map((s) {
                      return DropdownMenuItem(
                          child: Text('$s sugar(s)'), value: s);
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugar = val),
                  ),
                  //slider
                  SizedBox(
                    height: 20.0,
                  ),

                  Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                  ),

                  RaisedButton(
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugar ?? userData.sugar,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength);
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.pink[400],
                    child: Text(
                      'update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
