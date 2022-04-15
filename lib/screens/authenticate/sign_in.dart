import 'package:brew_crew/main.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleState;
  SignIn(this.toggleState);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  //text field state
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: const Text("Sign in to Brew Crew"),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleState();
            },
            icon: const Icon(Icons.person),
            label: const Text("Register"),
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
              onChanged: ((value) {
                setState(() {
                  email = value;
                });
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
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
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                //print("sign in attempted with $email and $password");
                if (_formKey.currentState!.validate()) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(content: Text('Attempting Sign-In')));
                  dynamic newUser = await _authService
                      .signInWithEmailAndPassword(email, password);
                  if (newUser == null) {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    scaffoldMessengerKey.currentState
                        ?.showSnackBar(const SnackBar(
                      content: Text('Error with sign-in. Try again'),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    scaffoldMessengerKey.currentState
                        ?.showSnackBar(const SnackBar(
                      content: Text('Sign-in Success!'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                }
              },
              child: const Text('Sign-In'),
            )
          ]),
        ),
      ),
    );
  }
}
