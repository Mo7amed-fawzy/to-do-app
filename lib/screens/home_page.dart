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
  List<Map<String, dynamic>> tempDeletedItems = [];

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
    // إذا كانت الحقول غير فارغة
    if (_todoTitle.text.isNotEmpty || _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text.isNotEmpty
            ? _todoTitle.text
            : "No Title", // قيمة بديلة
        "desc": _todoDesc.text.isNotEmpty
            ? _todoDesc.text
            : "No Description" // قيمة بديلة
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

  Future<void> deleteItem(
      String itemId, String title, String desc, int index) async {
    try {
      tempDeletedItems.add({
        'item': items![index],
        'index': index,
      });

      setState(() {
        items!.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Item deleted"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              restoreDeletedItem();
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));

      if (tempDeletedItems.isNotEmpty &&
          tempDeletedItems.last['item']['_id'] == itemId) {
        var regBody = {"itemId": itemId};

        var response = await http.post(
          Uri.parse(deleteTodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            printHere("Item deleted permanently");
          } else {
            printHere("Failed to delete item from server: $jsonResponse");
          }
        } else {
          printHere("Server error: ${response.statusCode}");
        }
      }
    } catch (e) {
      printHere("Exception occurred: $e");
    }
  }

  void restoreDeletedItem() {
    if (tempDeletedItems.isNotEmpty) {
      var deletedItem = tempDeletedItems.removeLast();

      setState(() {
        items!.insert(deletedItem['index'], deletedItem['item']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item restored")),
      );
    }
  }

  Future<void> updateTodo(String itemId, String title, String desc) async {
    var regBody = {
      "itemId": itemId,
      "title": title,
      "desc": desc,
    };

    toggleLoading(true);
    var response = await http.post(
      Uri.parse(updateTodos),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );
    toggleLoading(false);

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      printHere("Update Successful: ${jsonResponse['success']}");
      getTodoList(userId);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update Failed")),
      );
    }
  }

  // عند فتح نافذة التعديل
  Future<void> _showEditDialog(BuildContext context, String itemId,
      String currentTitle, String currentDesc) async {
    // إعادة تعيين القيم القديمة عند التعديل
    _todoTitle.text = currentTitle;
    _todoDesc.text = currentDesc;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit To-Do'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextDialogField(
                textController: _todoTitle,
                customHint: "Title",
              ).p4().px8(),
              CustomTextDialogField(
                textController: _todoDesc,
                customHint: "Description",
              ).p4().px8(),
              ElevatedButton(
                onPressed: () {
                  updateTodo(itemId, _todoTitle.text, _todoDesc.text);
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }

// عند إضافة مهمة جديدة
  Future<void> _displayTextInputDialog(BuildContext context) async {
    // مسح القيم عند إضافة مهمة جديدة
    _todoTitle.clear();
    _todoDesc.clear();

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
                    if (_todoTitle.text.isEmpty && _todoDesc.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("يعم متستهبلش اكتب حاجة")),
                      );
                    } else {
                      addTodo();
                    }
                  },
                  child: const Text("Add"),
                )
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30.0,
                            child: Icon(
                              Icons.list,
                              size: 30.0,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Column(
                            children: [
                              Text(
                                email,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                userId,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'ToDo with NodeJS + Mongodb',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Text(
                            'Tasks',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isLoading
                                ? 'Loading...'
                                : items != null
                                    ? items!.length.toString()
                                    : '0',
                            style: const TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ],
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
                    child: items == null || items!.isEmpty
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
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      borderRadius: BorderRadius.circular(10),
                                      label: 'Edit',
                                      onPressed: (BuildContext context) {
                                        // استدعاء نافذة التعديل
                                        _showEditDialog(
                                          context,
                                          items![index]['_id'],
                                          items![index]['title'],
                                          items![index]['desc'],
                                        );
                                      },
                                    ),
                                    SlidableAction(
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      borderRadius: BorderRadius.circular(10),
                                      label: 'Delete',
                                      onPressed: (BuildContext context) {
                                        String title = items![index]['title'];
                                        String desc = items![index]['desc'];
                                        String itemId = items![index]['_id'];
                                        deleteItem(itemId, title, desc, index);
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
