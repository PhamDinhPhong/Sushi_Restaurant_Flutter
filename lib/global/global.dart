import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Color? primaryColor = Color.fromARGB(255, 138, 60, 55);
Color? secondaryColor = Color.fromARGB(109, 140, 94, 91);
