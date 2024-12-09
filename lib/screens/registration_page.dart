import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/core/func/custom_border_style.dart';
import 'package:to_do_app/core/func/orange_page_gradient.dart';
import 'package:to_do_app/core/utils/config.dart';
import 'package:to_do_app/screens/widgets/custom_text_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
// import 'package:to_do_app/utils/config.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      printHere(jsonResponse['status']);

      if (jsonResponse['status']) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        }
      } else {
        printHere("Something Went Wrong");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
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
                  "CREATE YOUR ACCOUNT".text.size(22).yellow100.make(),
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            final data =
                                ClipboardData(text: passwordController.text);
                            Clipboard.setData(data);
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.password),
                          onPressed: () {
                            String passGen = generatePassword();
                            passwordController.text = passGen;
                            setState(() {});
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: const TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        hintText: "Password",
                        border: customBorderStyle()),
                  ).p4().px24(),
                  HStack([
                    GestureDetector(
                      onTap: () => {registerUser()},
                      child: VxBox(
                              child: "Register".text.white.makeCentered().p16())
                          .green600
                          .roundedLg
                          .make()
                          .px16()
                          .py16(),
                    ),
                  ]),
                  GestureDetector(
                    onTap: () {
                      printHere("Sign In");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                    },
                    child: HStack([
                      "Already Registered?".text.make(),
                      " Sign In".text.white.make()
                    ]).centered(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
