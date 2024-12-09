import 'package:flutter/foundation.dart';

const url = 'http://192.168.29.239:3000/';
const registration = "${url}registration";
const login = '${url}login';
const addtodo = '${url}storeTodo';
const getToDoList = '${url}getUserTodoList';
const deleteTodo = '${url}deleteTodo';

printHere(var obj) {
  if (kDebugMode) {
    print(obj);
  }
}
