import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:firbase_login_crud_app/ui/auth/login_screen.dart';
import 'package:firbase_login_crud_app/ui/posts/post_screen.dart';
import 'package:firbase_login_crud_app/utils/utils.dart';
import 'package:firbase_login_crud_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text('Signup'),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                            label: Text('e-mail'),
                            prefixIcon: Icon(Icons.email_rounded)),
                        validator: (value) {
                          bool emailFormat = EmailValidator.validate(value!);
                          if (value.isEmpty || emailFormat == false) {
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          label: Text('Password'),
                          // helperText: 'Remember password',
                          prefixIcon: Icon(Icons.lock_open)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: RoundButton(
                title: 'Signup',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    _auth
                        .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                    }).catchError((error, stackTrace) {
                      print('hai{$error}');

                      // Utils().toastmessage(errormsg);
                      setState(() {
                        loading = false;
                        this.error = error.toString();
                      });
                    });
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PostScreen();
                  }));
                },
              ),
            ),
            // Text('hai $errormsg'),
            Text(error),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Log in'))
              ],
            )
          ],
        ));
  }
}
