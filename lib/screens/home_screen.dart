// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/movie_model.dart';
import 'add_edit_movie.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];

  String _searchQuery = '';
  String _statusFilter = 'All'; // All, Watched, Not Watched
  String _sortBy = 'Title';     // Title, Rating, Year

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() async {
    final data = await DBHelper().getAllMovies();
    setState(() {
      _movies = data;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Movie> temp = [..._movies];

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((m) =>
          m.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by watch status
    if (_statusFilter != 'All') {
      temp = temp.where((m) => m.status == _statusFilter).toList();
    }

    // Sort the list
    temp.sort((a, b) {
      switch (_sortBy) {
        case 'Rating':
          return b.rating.compareTo(a.rating);
        case 'Year':
          return b.releaseYear.compareTo(a.releaseYear);
        default:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });

    _filteredMovies = temp;
  }

  @override
  Widget build(BuildContext context) {
    _applyFilters(); // reapply filters before building

    return Scaffold(
      appBar: AppBar(
        title: Text('🎬 My Movie Watchlist'),
      ),
      body: Column(
        children: [
          _buildFilterControls(),
          Expanded(
            child: _filteredMovies.isEmpty
                ? Center(child: Text("No movies found."))
                : ListView.builder(
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = _filteredMovies[index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle:
                  Text("${movie.genre} • ${movie.releaseYear}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("⭐ ${movie.rating}/10"),
                      Text(movie.status, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsScreen(
                          movie: movie,
                          onUpdated: _refreshList,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditMovieScreen()),
          );
          _refreshList();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search by title",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _statusFilter,
                  decoration: InputDecoration(labelText: "Status"),
                  items: ['All', 'Watched', 'Not Watched']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _statusFilter = value!);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _sortBy,
                  decoration: InputDecoration(labelText: "Sort by"),
                  items: ['Title', 'Rating', 'Year']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _sortBy = value!);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
