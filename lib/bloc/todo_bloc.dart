import 'package:bloc_sqflite_flutter/data/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final db = DatabaseHelper.instance;

  TodoBloc() : super(TodoLoading()) {
    on<LoadTodos>((event, emit) async {
      final todos = await db.fetchTodos();
      emit(TodoLoaded(todos));
    });

    on<AddTodo>((event, emit) async {
      await db.insertTodo(event.todo);
      add(LoadTodos());
    });

    on<UpdateTodo>((event, emit) async {
      await db.updateTodo(event.todo);
      add(LoadTodos());
    });

    on<DeleteTodo>((event, emit) async {
      await db.deleteTodo(event.id);
      add(LoadTodos());
    });
  }
}
