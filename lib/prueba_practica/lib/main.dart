import 'package:flutter/material.dart';
import 'dart:async';
import 'task_modelo.dart';
import 'task_servicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskServicio.fetchTasks();
  }

  @override
  Widget build(BuildContext contect) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final taskList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index){
              final task = taskList[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.status),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final task = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskCreateScreen(),
          ),
        );
        if (task != null) {
          setState(() {
            tasks = TaskServicio.fetchTasks();
            });
        }
      },
      child: Icon(Icons.add),
      )
    );
  }
}

class TaskCreateScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [ 
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Descripción'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;
                final task = await TaskServicio.createTask(title, description);
                Navigator.pop(context, task);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}



