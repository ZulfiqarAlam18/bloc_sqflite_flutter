import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo App")),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeleteTodo(todo.id!));
                    },
                  ),
                  onTap: () {
                    titleController.text = todo.title;
                    descController.text = todo.description;
                    _showDialog(context, isEdit: true, todo: todo);
                  },
                );
              },
            );
          }
          return Center(child: Text("No Todos"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          titleController.clear();
          descController.clear();
          _showDialog(context);
        },
      ),
    );
  }

  void _showDialog(BuildContext context, {bool isEdit = false, Todo? todo}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            child: Text(isEdit ? "Update" : "Add"),
            onPressed: () {
              if (isEdit) {
                context.read<TodoBloc>().add(UpdateTodo(
                  Todo(id: todo!.id, title: titleController.text, description: descController.text),
                ));
              } else {
                context.read<TodoBloc>().add(AddTodo(
                  Todo(title: titleController.text, description: descController.text),
                ));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
