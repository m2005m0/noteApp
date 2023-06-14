import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note101_app/auth/login.dart';
import 'package:note101_app/auth/signup.dart';
import 'package:note101_app/edit_note/add_note.dart';
import 'package:note101_app/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

var islogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    islogin = false;
  }else{
    islogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin? const HomePage() :  const Login(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.red,
        ),
      ),
      routes: {
        'login': (context) => const Login(),
        'signUp': (context) => const SignUp(),
        'homePage': (context) => const HomePage(),
        'addNote': (context) => const AddNote(),
      },
    );
  }
}
