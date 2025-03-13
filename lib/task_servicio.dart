import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'task_modelo.dart';


class TaskServicio {
  static const String baseUrl = 'http://127.0.0.1:8000/api/tasks';

  // Obtiene Tareas
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['tasks'];
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Crea una Tarea
  static Future<Task> createTask(String title, String description) async {
    final response = await http.post(Uri.parse(baseUrl), 
      headers: {'Content-type': 'application/json'},
      body: json.encode({'title': title, 'description': description}),
      );
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create task');
      }
  }

  // Elimina Tarea
  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + '/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // Actualizar Tarea
  static Future<Task> updateTask(int id, String title, String description, String status) async {
    final response = await http.put(Uri.parse(baseUrl + '/$id'),
      body: json.encode({
        'title': title,
        'description': description,
        'status': status
      }),);
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }
}