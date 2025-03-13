import 'package:flutter/material.dart';

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
      theme: ThemeData( PrimarySwatch: Colors.blue),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      ),
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
    tasks = TaskService.fetchTasks();
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
              onTap: () {
                Navigator.push()
              },
            );
          },
        )
      );
    );
  }
}



