import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndp_sushi_restaurant/Authentication/register.dart';
import 'package:ndp_sushi_restaurant/provider/form_state.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/pages/intro_page.dart';
import 'package:ndp_sushi_restaurant/pages/menu_page.dart';
import 'package:ndp_sushi_restaurant/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please write email & password",
            );
          }
      );
    }
  }


  // Future<void> launch(String url, {bool isNewTab = true}) async {
  //   await launchUrl(
  //     Uri.parse(url),
  //     webOnlyWindowName: isNewTab ? '_blank' : '_self',
  //   );
  // }


  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Checking Credentials",
          );
        }
    );

    User? currentUser;
    print(currentUser);

    // @override
    // Future<void> initState() async {
    //   super.initState();
    //   _auth.authStateChanges().listen((event) {
    //     setState(() {
    //       currentUser = event;
    //     });
    //   });
    // }

    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      readDataAndSetLocally(currentUser!);
    }
  }

  Future readDataAndSetLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("email", snapshot.data()!["email"]);
          await sharedPreferences!.setString("uid", snapshot.data()!["name"]);
          // await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);

          List<String> userCartList =
          snapshot.data()!["userCart"].cast<String>();

          await sharedPreferences!.setStringList("userCart", userCartList);

          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MenuPage()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Admin has blocked your account");
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const IntroPage()));
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "No record found",
              );
            }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Login Screen",
          style: TextStyle(
            fontSize: 20,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Consumer<LoginFormData>(
                builder: (context, loginFormData, _) => TextButton(
                    onPressed: loginFormData.isButtonEnabled()
                        ? () {
                      formValidation();
                    }
                        : null,
                    child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: loginFormData.isButtonEnabled()
                              ? primaryColor
                              : Colors.grey,
                        )
                    )
                )
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Center(
                        child: Image.asset(
                          "images/sushi(4).png",
                          width: 145,
                          height: 145,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Info",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),


                    // const SizedBox(
                    //   height: 15,
                    // ),
                    const Text(
                      "We'll check if you have an account",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        CustomTextField(
                          data: Icons.email,
                          controller: emailController,
                          hintText: "Email",
                          isObsecre: false,
                          onChanged: (value) {
                            Provider.of<LoginFormData>(context, listen: false)
                                .email = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.lock,
                          controller: passwordController,
                          hintText: "Password",
                          isObsecre: true,
                          onChanged: (value) {
                            Provider.of<LoginFormData>(context, listen: false)
                                .password = value;
                          },
                        )
                      ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Doesn't have an account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const RegisterScreen()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}



