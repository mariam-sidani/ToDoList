import 'package:flutter/material.dart';
import 'todo_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  List toDoList = [
    ['Learn Web Development', false],
    ['Drink coffee', false],
  ];
  List filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = toDoList;
  }

  void checkBoxChanged(int index) {
    setState(() {
      filteredList[index][1] = !filteredList[index][1];
    });
  }

  void saveNewTask() {
    if (_controller.text.trim().isEmpty) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Input-Error"),
            content:
                const Text("Task cannot be empty. Please enter a valid task."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Add the task
      setState(() {
        toDoList.add([_controller.text, false]);
        _controller.clear();
        filterTasks('');
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      filterTasks('');
    });
  }

  void editTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final editController = TextEditingController(
          text: filteredList[index][0],
        );
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: "Update task name",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  toDoList[toDoList.indexOf(filteredList[index])][0] =
                      editController.text;
                  filterTasks('');
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void filterTasks(String query) {
    setState(() {
      filteredList = toDoList
          .where((task) => task[0].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow
      backgroundColor: const Color.fromARGB(255, 255, 255, 225),
      appBar: AppBar(
        title: const Text(' Todo-List'),
        backgroundColor: const Color.fromARGB(255, 205, 193, 255),
        foregroundColor: const Color.fromARGB(255,255, 246,277),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                onChanged: filterTasks,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  filled: true,
                  fillColor: const Color.fromARGB(198, 255, 253, 252),
                  prefixIcon:
                      const Icon(Icons.search, color: Color.fromARGB(255, 57, 73, 219)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(140, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 72, 97, 226)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            // Task List
            ListView.builder(
              shrinkWrap: true, // Prevents unbounded height
              physics:
                  const NeverScrollableScrollPhysics(), // Avoids nested scrolling
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, index) {
                return TodoList(
                  taskName: filteredList[index][0],
                  taskCompleted: filteredList[index][1],
                  onChanged: (value) => checkBoxChanged(index),
                  deleteFunction: (value) => deleteTask(index),
                  editFunction: (value) => editTask(index),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add new todo items',
                  filled: true,
                  fillColor: Colors.deepPurple.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(179, 37, 37, 37)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 72, 57, 188)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: saveNewTask,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
