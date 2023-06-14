import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var myEmail, myPassword;



  signIn() async {
    var formData = formState.currentState;
    if (formData != null) {
      if (formData.validate()) {
        formData.save();
        try {
          showLoading(context);
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: myEmail, password: myPassword);
          return credential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Navigator.of(context).pop();
            AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No user found for that email.'),
              ),
            ).show();
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            Navigator.of(context).pop();
            AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Wrong password provided for that user.'),
              ),
            ).show();
            print('Wrong password provided for that user.');
          }
        }
      } else {
        print('not valid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 150.0,
          ),
          Image.asset(
            'images/pencil.png',
            width: 150,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myEmail = val;
                    },
                    validator: (val) {
                      if (val != null) {
                        if ((!val.contains('@')) || (!val.contains('.com'))) {
                          return 'Please enter valid email';
                        }
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      myPassword = val;
                    },
                    validator: (val) {
                      if (val != null) {
                        if (val.length > 100) {
                          return 'Password can\'t more that 100 letter';
                        }
                        if (val.length < 4) {
                          return 'Password should be more than 4 letters';
                        }
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Text('If you don\'t have account '),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('signUp');
                        },
                        child: const Text(
                          'click here',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: () async {
                      var user = await signIn();
                      if(user != null)  {
                        Navigator.of(context).pushReplacementNamed('homePage');
                      }else{
                        print('SignIn not valid');
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
