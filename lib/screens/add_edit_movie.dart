// lib/screens/add_edit_movie.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/movie_model.dart';

class AddEditMovieScreen extends StatefulWidget {
  final Movie? movie;

  AddEditMovieScreen({this.movie});

  @override
  _AddEditMovieScreenState createState() => _AddEditMovieScreenState();
}

class _AddEditMovieScreenState extends State<AddEditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();

  String _status = 'Not Watched';
  int _rating = 1;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _genreController.text = widget.movie!.genre;
      _yearController.text = widget.movie!.releaseYear.toString();
      _notesController.text = widget.movie!.notes;
      _status = widget.movie!.status;
      _rating = widget.movie!.rating;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        genre: _genreController.text,
        releaseYear: int.tryParse(_yearController.text) ?? 0,
        status: _status,
        rating: _rating,
        notes: _notesController.text,
      );

      if (widget.movie == null) {
        await DBHelper().insertMovie(movie);
      } else {
        await DBHelper().updateMovie(movie);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Movie" : "Add Movie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Movie Title"),
                validator: (value) => value!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(labelText: "Genre"),
                validator: (value) => value!.isEmpty ? "Enter genre" : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: "Release Year"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Enter release year" : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: "Watch Status"),
                items: ["Watched", "Not Watched"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              DropdownButtonFormField<int>(
                value: _rating,
                decoration: InputDecoration(labelText: "Rating"),
                items: List.generate(
                  10,
                      (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1}")),
                ),
                onChanged: (value) => setState(() => _rating = value!),
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: "Notes"),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovie,
                child: Text(isEditing ? "Update Movie" : "Add Movie"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
