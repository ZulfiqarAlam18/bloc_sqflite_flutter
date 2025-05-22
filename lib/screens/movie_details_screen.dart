// lib/screens/movie_details_screen.dart
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../db/db_helper.dart';
import 'add_edit_movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;
  final VoidCallback onUpdated;

  const MovieDetailsScreen({required this.movie, required this.onUpdated});

  void _deleteMovie(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Movie"),
        content: Text("Are you sure you want to delete '${movie.title}'?"),
        actions: [
          TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(child: Text("Delete"), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper().deleteMovie(movie.id!);
      onUpdated();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Details"),

        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditMovieScreen(movie: movie),
                ),
              );
              onUpdated();
              Navigator.pop(context); // Close details after edit
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteMovie(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              movie.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              "${movie.genre} • ${movie.releaseYear}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Status: ${movie.status}"),
                Spacer(),
                Text("⭐ ${movie.rating}/10"),
              ],
            ),
            Divider(height: 24),
            Text(
              "Notes",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(movie.notes.isNotEmpty ? movie.notes : "No notes added."),
          ],
        ),
      ),
    );
  }
}
