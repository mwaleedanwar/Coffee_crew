import 'package:brew_crew/main.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleState;
  Register(this.toggleState);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: const Text("Register to Brew Crew"),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleState();
            },
            icon: const Icon(Icons.person),
            label: const Text("Sign-in"),
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: ((value) {
                setState(() {
                  email = value;
                });
              }),
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(content: Text('Attempting Registration')));
                  dynamic newUser = await _authService
                      .registerWithEmailAndPassword(email, password);
                  if (newUser == null) {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    scaffoldMessengerKey.currentState
                        ?.showSnackBar(const SnackBar(
                      content: Text('Error with registration. Try again.'),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    scaffoldMessengerKey.currentState
                        ?.showSnackBar(const SnackBar(
                      content: Text('Registation Success!'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                }
              },
              child: const Text('Register'),
            )
          ]),
        ),
      ),
    );
  }
}
