import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todoBox = Hive.box('todoBox');

  TextEditingController _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do with Hive'),
      ),
      body: _todoBox.isEmpty
          ? Center(
              child: Text('No data'),
            )
          : ListView.builder(
              itemCount: _todoBox.length,
              itemBuilder: (context, index) {
                final _todo = _todoBox.getAt(index);
                return ListTile(
                  leading: Checkbox(
                      value: _todo['isCompleted'],
                      onChanged: (clickingValue) {
                        _todo['isCompleted'] = clickingValue ?? false;
                        setState(() {});
                      }),
                  title: Text(_todo['task']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            editDialodBox(context, index);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            _deleteTask(index);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //DELETE TASK
  void _deleteTask(int index) {
    setState(() {
      _todoBox.deleteAt(index);
    });
  }

  //SAVE TASK
  void _saveTask() {
    setState(() {
      _todoBox.add({'task': _taskController.text, 'isCompleted': false});

      _taskController.clear();
      Navigator.pop(context);
    });
  }

  //UPDATE TASK
  void _updateTask(int index) {
    final todo = _todoBox.getAt(index);
    todo['task'] = _taskController.text;
    setState(() {
      _todoBox.putAt(index, todo);

      _taskController.clear();
      Navigator.pop(context);
    });
  }

  //EDIT DIALOG
  void editDialodBox(BuildContext context, int index) {
    final _todo = _todoBox.getAt(index);
    _taskController.text = _todo['task'];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Task'),
            content: Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: _taskController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Edit here'),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _updateTask(index);
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  //ADD TASK
  void _addTask(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Task'),
            content: Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: _taskController,
                  decoration: InputDecoration(
                      hintText: 'Add task here', border: InputBorder.none),
                )),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      _saveTask();
                    } else {
                      null;
                    }
                  },
                  child: Text('Save')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }
}
