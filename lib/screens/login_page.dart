import 'package:flutter/material.dart';
import 'package:to_do_app/core/func/custom_border_style.dart';
import 'package:to_do_app/core/services/login_service.dart';
import 'package:to_do_app/screens/home_page.dart';
import 'package:to_do_app/screens/registration_page.dart';
import 'package:to_do_app/screens/widgets/custom_text_field.dart';
import 'package:velocity_x/velocity_x.dart';
import '../core/func/orange_page_gradient.dart';
import 'widgets/applogo.dart';
import 'package:to_do_app/core/utils/config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final bool _isNotValidate = false;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: myPageGradient(),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CommonLogo(),
                  const HeightBox(10),
                  "Email Sign-In".text.size(22).yellow100.make(),
                  CustomTextField(
                          controller: emailController,
                          isNotValidate: _isNotValidate,
                          myhintText: "Email")
                      .p4()
                      .px24(),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: customBorderStyle()),
                  ).p4().px24(),
                  GestureDetector(
                    onTap: () {
                      const LoginService().loginUser((token) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(token: token),
                          ),
                        );
                      });
                    },
                    child: HStack([
                      VxBox(child: "LogIn".text.white.makeCentered().p16())
                          .green600
                          .roundedLg
                          .make(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Registration()));
          },
          child: Container(
              height: 25,
              color: Colors.lightBlue,
              child: Center(
                  child: "Create a new Account..! Sign Up"
                      .text
                      .white
                      .makeCentered())),
        ),
      ),
    );
  }
}
