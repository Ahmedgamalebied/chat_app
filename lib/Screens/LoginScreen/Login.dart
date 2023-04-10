import 'package:chat_app/Component/textfield.dart';
import 'package:chat_app/Screens/Chat_Screen/chat_screen.dart';
import 'package:chat_app/Screens/Sign_up_Screen/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Component/defaultBatton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  static String id = 'login page';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: ListView(
              children: [
                Image.asset('assets/images/chat_logo.webp'),
                const Center(
                  child: Text(
                    'Welcome to my chat App',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                MyTextField(
                  onChange: (data) {
                    email = data;
                  },
                  obscureText: false,
                  labelText: 'Email',
                  hintText: 'Enter email please',
                  keyboardType: TextInputType.emailAddress,
                  keyboradType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 18,
                ),
                MyTextField(
                  onChange: (data) {
                    password = data;
                  },
                  obscureText: true,
                  labelText: 'Password',
                  hintText: 'Enter password please',
                  keyboardType: TextInputType.visiblePassword,
                  keyboradType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 18,
                ),
                DefaultButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      inAsyncCall = true;
                      setState(() {});
                      try {
                        var auth = FirebaseAuth.instance;
                        await LoginUser(auth);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success')));
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, ChatScreen.id,
                            arguments: email);
                        // } on FirebaseAuthException catch (ex) {
                        //   if (ex.code == 'user Not found') {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text('User Not found ')));
                        //   } else if (ex.code == 'Wrong password') {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text('Wrong password')));
                        //   }
                      } catch (ex) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('there was an error')));
                      }
                      inAsyncCall = false;
                      setState(() {});
                    }
                  },
                  text: "Log in ",
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RegisterScreen.id,
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginUser(FirebaseAuth auth) async {
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }
}
