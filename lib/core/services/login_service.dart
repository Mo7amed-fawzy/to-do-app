import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/core/utils/config.dart';
import 'package:http/http.dart' as http;

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginService {
  const LoginService();
  void loginUser(Function(String) navPage) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        navPage(myToken);
      } else {
        printHere('Something went wrong');
      }
    }
  }
}
