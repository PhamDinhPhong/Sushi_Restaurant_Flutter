import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/Authentication/login.dart';
import 'package:ndp_sushi_restaurant/provider/form_state.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/pages/menu_page.dart';
import 'package:ndp_sushi_restaurant/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  Future<void> formValidation() async {
    if (passwordController.text == confirmPasswordController.text) {
      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          photoUrlController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(
                message: "Registering Account",
              );
            });

        // String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        // fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
        // fStorage.TaskSnapshot taskSnapshot = await up
        // await taskSnapshot.ref.getDownloadURL().then(url) {
        //   photoUrl = url;
        //   authentication();
        // };
        authentication();
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please enter all the fields data.",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password do not match.",
            );
          });
    }
  }

  void authentication() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
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
      saveDataToFirestorage(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MenuPage()));
      });
    }
  }

  Future saveDataToFirestorage(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": photoUrlController.text.trim(),
      "status": "approved",
      "userCart": ["garbageValue"],
    });
    // Luu du lieu
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!
        .setString("photoUrl", photoUrlController.text.trim());
    await sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        title: Text(
          "Register Page",
          style: TextStyle(
            fontSize: 20,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(1),
            child: Consumer<RegisterFormData>(
                builder: (context, registerFormData, _) => TextButton(
                    onPressed: registerFormData.isButtonEnabled()
                        ? () {
                      formValidation();
                    }
                        : null,
                    child: Text("Continue",
                        style: TextStyle(
                          color: registerFormData.isButtonEnabled()
                              ? primaryColor
                              : Colors.grey,
                        )))),
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
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Center(
                        child: Image.asset(
                          'images/sushi (2).png',
                          width: 145,
                          height: 145,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    const Text(
                      "Info",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // SizedBox(
                    //   height: 10,
                    // ),

                    Form(
                      key: _formKey,
                      child: Column(children: [
                        CustomTextField(
                          data: Icons.person,
                          controller: nameController,
                          hintText: "Name",
                          isObsecre: false,
                          onChanged: (value) {
                            Provider.of<RegisterFormData>(context,
                                listen: false)
                                .name = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.email,
                          controller: emailController,
                          hintText: "Email",
                          isObsecre: false,
                          onChanged: (value) {
                            Provider.of<RegisterFormData>(context,
                                listen: false)
                                .email = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.photo,
                          controller: photoUrlController,
                          hintText: "Link Avatar",
                          isObsecre: false,
                          onChanged: (value) {
                            Provider.of<RegisterFormData>(context,
                                listen: false)
                                .photoUrl = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.lock,
                          controller: passwordController,
                          hintText: "Password",
                          isObsecre: true,
                          onChanged: (value) {
                            Provider.of<RegisterFormData>(context,
                                listen: false)
                                .password = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.lock,
                          controller: confirmPasswordController,
                          hintText: "Confirm Password",
                          isObsecre: true,
                          onChanged: (value) {
                            Provider.of<RegisterFormData>(context,
                                listen: false)
                                .confirmPassword = value;
                          },
                        ),
                      ]),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Already have an account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),

                        SizedBox(
                          width: 5,
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => LoginScreen()));
                          },

                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
