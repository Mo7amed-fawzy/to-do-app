import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:to_do_app/core/utils/config.dart';
import 'package:to_do_app/screens/widgets/custom_dialog_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({required this.token, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  late String email;
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDesc = TextEditingController();
  List? items;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    userId = jwtDecodedToken['_id'];
    printHere(email);
    printHere(userId);
    getTodoList(userId);
  }

  void toggleLoading(bool state) {
    setState(() {
      isLoading = state;
      const Center(child: CircularProgressIndicator());
    });
  }

  Future<void> addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };

      toggleLoading(true);
      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      toggleLoading(false);

      var jsonResponse = jsonDecode(response.body);
      if (mounted) {
        if (jsonResponse['status']) {
          _todoDesc.clear();
          _todoTitle.clear();
          Navigator.pop(context);
          getTodoList(userId);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")),
        );
      }
    }
  }

  void getTodoList(userId) async {
    var regBody = {"userId": userId};
    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];
    setState(() {});
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add To-Do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextDialogField(
                        textController: _todoTitle, customHint: "Title")
                    .p4()
                    .px8(),
                CustomTextDialogField(
                        textController: _todoDesc, customHint: "Description")
                    .p4()
                    .px8(),
                ElevatedButton(
                    onPressed: () {
                      addTodo();
                    },
                    child: const Text("Add"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30.0,
                        child: Icon(
                          Icons.list,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'ToDo with NodeJS + Mongodb',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Tasks',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: items == null
                        ? const Center(child: Text("No tasks available"))
                        : ListView.builder(
                            itemCount: items!.length,
                            itemBuilder: (context, int index) {
                              return Slidable(
                                key: ValueKey(items![index]['_id']),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (BuildContext context) {
                                        // Handle delete action here
                                      },
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.task),
                                    title: Text(items![index]['title']),
                                    subtitle: Text(items![index]['desc']),
                                    trailing: const Icon(Icons.arrow_back),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        tooltip: 'Add-ToDo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
