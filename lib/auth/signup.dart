import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:note101_app/component/alert.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var myUserName, myEmail, myPassword;

  signUp() async {
    var formData = formState.currentState;
    if (formData != null) {
      if (formData.validate()) {
        formData.save();
        try {
          showLoading(context);
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: myEmail,
            password: myPassword,
          );
          return credential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Navigator.of(context).pop();
            AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('The password is too weak.',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ).show();
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            Navigator.of(context).pop();
            AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'The account already exists for that email.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ).show();
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
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
            height: 150,
            width: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myUserName = val;
                    },
                    validator: (val) {
                      if (val != null) {
                        if (val.length > 100) {
                          return 'User Name can\'t be more than 100 letter';
                        }
                        if (val.length < 4) {
                          return 'User Name should be more than 4 letter';
                        }
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      hintText: 'User Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
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
                      const Text('If you have account '),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('login');
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
                      var response = await signUp();
                      if(response != null){
                        await FirebaseFirestore.instance.collection('users').add(
                            {
                              'username' : myUserName,
                              'email' : myEmail,
                            });
                        Navigator.pushReplacementNamed(context, 'homePage');
                      }else{
                        print('SignUp has faild');
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        'Sign up',
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
