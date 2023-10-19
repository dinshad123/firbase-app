import 'package:email_validator/email_validator.dart';
import 'package:firbase_login_crud_app/ui/auth/sign_up_screen.dart';
import 'package:firbase_login_crud_app/ui/posts/post_screen.dart';
import 'package:firbase_login_crud_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String error = '';
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const PostScreen();
      }));
    }).onError((error, stackTrace) {
      setState(() {
        this.error = error.toString();
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          this.error = '';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text('Login'),
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
                title: 'Login',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(error),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dont have an account'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: const Text('Sign up'))
              ],
            )
          ],
        ));
  }
}
