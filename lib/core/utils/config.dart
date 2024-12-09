import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = 'http://192.168.1.3:8080/';
const registration = "${url}registration";
const login = '${url}login';
const addtodo = '${url}storeTodo';
const getToDoList = '${url}getUserTodoList';
const deleteTodo = '${url}deleteTodo';
late SharedPreferences prefs;

printHere(var obj) {
  if (kDebugMode) {
    print(obj);
  }
}

void initSharedPref() async {
  prefs = await SharedPreferences.getInstance();
}
