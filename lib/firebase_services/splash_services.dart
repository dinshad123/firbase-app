import 'dart:async';
import 'package:firbase_login_crud_app/ui/auth/login_screen.dart';
import 'package:firbase_login_crud_app/ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async{
    final auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
    } catch (e) {
      // Handle any potential errors here
    }
    
    final user = auth.currentUser;
    if (user == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } if(user!=null) {
      print('hai$user');
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen
              ())));
    }
  }
}
