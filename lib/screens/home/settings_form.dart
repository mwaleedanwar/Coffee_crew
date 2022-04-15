import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  //for form
  final _formKey = GlobalKey<FormState>();
  //for the dropdown list
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  //form values need to private
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    customUser user = Provider.of<customUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(user.uid).userData,
        builder: (context, snapshot) {
          //snapshot is stream data not firebase snapshot
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(children: [
                const Text(
                  'Update brew settings',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: userData!.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(width: 1, color: Colors.grey.shade600)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(width: 3, color: Colors.brown.shade300)),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter a name'
                      : null,
                  onChanged: (value) => setState(() => _currentName = value),
                ),
                const SizedBox(
                  height: 20,
                ),
                //dropdown
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey.shade600)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey.shade600)),
                    ),
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar, child: Text("$sugar sugars"));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _currentSugars = value.toString());
                    }),
                const SizedBox(
                  height: 20,
                ),
                //slider
                Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    onChanged: (value) =>
                        setState(() => _currentStrength = value.round())),

                //update button
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(user.uid).updateUserdata(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Update'))
              ]),
            );
          } else {
            return Container(
              child: Text('something went fucky'),
            );
          }
        });
  }
}
