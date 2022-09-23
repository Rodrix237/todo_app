import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/components/dialog_box.dart';
import 'package:todoapp/components/task_tile.dart';
import 'package:todoapp/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBoxDB = Hive.box('my_database');
  TaskDataBase db = TaskDataBase();

  @override
  void initState() {
    if (_myBoxDB.get("TASKLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  //Text Controller
  final _controller = TextEditingController();

  //Check box switch
  checkBoxChanged(bool? value, int index) {
    setState(() {
      db.taskList[index][1] = !db.taskList[index][1];
    });
    db.updateDataBase();
  }

  //Save New Task
  void saveNewTask() {
    setState(() {
      db.taskList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //Create New Task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.taskList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('TO DO'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: db.taskList.isEmpty ? const Center(child: Text("Aucune tâche. Super !", style: TextStyle(fontSize: 16),),) : ListView.builder(
        itemCount: db.taskList.length,
        itemBuilder: (context, index) {
          return TaskTile(
            taskName: db.taskList[index][0],
            taskCompleted: db.taskList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
