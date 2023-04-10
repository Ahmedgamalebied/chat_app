import 'package:chat_app/Component/defaultBatton.dart';
import 'package:chat_app/Screens/Chat_Screen/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Component/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });
  static String id = 'RegisterScreen ';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool inAsyncCall = false;
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: ListView(children: [
              Image.asset('assets/images/chat_logo.webp'),
              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              MyTextField(
                  onChange: (data) {
                    email = data;
                  },
                  obscureText: false,
                  labelText: 'Email',
                  hintText: 'Enter email please',
                  keyboradType: TextInputType.emailAddress,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(
                height: 18,
              ),
              MyTextField(
                  onChange: (data) {
                    password = data;
                  },
                  obscureText: true,
                  labelText: 'pass',
                  hintText: 'Enter password please',
                  keyboradType: TextInputType.visiblePassword,
                  keyboardType: TextInputType.visiblePassword),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DefaultButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            inAsyncCall = true;
                            setState(() {});
                            try {
                              var auth = FirebaseAuth.instance;
                              await register(auth);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Success')));
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, ChatScreen.id,
                                  arguments: email);
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('weak password')));
                              } else if (ex.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('email already exists')));
                              }
                            } catch (ex) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('there was an error')));
                            }
                            inAsyncCall = false;
                            setState(() {});
                          }
                        },
                        text: "Register",
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("you have accout "),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Sign in')),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> register(FirebaseAuth auth) async {
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }
}
