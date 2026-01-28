import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftc_analyzer/DivisionSelect.dart';
import 'HomePage.dart';
import 'colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController, passwordController;
  double screenHeight = 0;
  double screenWidth = 0;
  bool isObscure = true;
  bool showvalue = false;
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/start_bg.jpeg"),
              //   fit: BoxFit.cover,
              // ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Cooper", fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                   EmailValidationTextField(
                    whenTextFieldEmpty: "Please enter  email",
                    validatorMassage: "Please enter valid email",
                    decoration: const InputDecoration(
                        labelText: ' Email ',
                        labelStyle: TextStyle(
                          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                          fontFamily: "Cooper",
                          fontStyle: FontStyle.normal,
                        ),
                        prefixIcon: Icon(Icons.email_rounded, color: Colors.black,),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                    ),
                    // textEditingController: emailController,
                    textEditingController: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height : 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PassWordValidationTextFiled(
                        lineIndicator:false,
                        passwordMinError: "Must be more than 6 characters",
                        hasPasswordEmpty: "Password is Empty",
                        passwordMaxError: "Password too Long",
                        passWordUpperCaseError: "At least one Uppercase(Capital) letter",
                        passWordDigitsCaseError: "At least one digit",
                        // passwordLowercaseError: "At least one lowercase character",
                        passWordSpecialCharacters: "At least one Special Characters",
                        obscureText: isObscure,
                        scrollPadding: const EdgeInsets.only(left: 60),
                        // onChanged: (value) {
                        //   // print(value);
                        // },
                        passTextEditingController: passwordController,
                        passwordMaxLength: 12,
                        passwordMinLength: 6,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            labelText: ' Password ',
                            labelStyle: TextStyle(
                              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                              fontFamily: "Cooper",
                              fontStyle: FontStyle.normal,
                            ),
                            prefixIcon: Icon(Icons.password_outlined, color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterText: '',
                            hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            // color: Colors.white,
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: isObscure ? const Icon(FontAwesomeIcons.eye, size: 22,) : const Icon(FontAwesomeIcons.eyeSlash, size: 22,)
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height : 20),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () async{
                      print(emailController?.text);
                      print(passwordController?.text);

                      showDialog(context: context, builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController!.text,
                          password: passwordController!.text,
                        );

                        Navigator.pop(context);

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DivisionSelect(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        Navigator.pop(context);

                        print(e.code);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Either Username or Password is Incorrect!'),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(double.infinity, 50),
                      // textStyle: TextStyle(fontSize: 14),
                      shadowColor: darkThemeColor,
                      elevation: 5,
                    ),
                    child: const Text("LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: "Cooper",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height : 20),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

