// lib/models/movie_model.dart
class Movie {
  int? id;
  String title;
  String genre;
  int releaseYear;
  String status;
  int rating;
  String notes;

  Movie({
    this.id,
    required this.title,
    required this.genre,
    required this.releaseYear,
    required this.status,
    required this.rating,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'release_year': releaseYear,
      'status': status,
      'rating': rating,
      'notes': notes,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      releaseYear: map['release_year'],
      status: map['status'],
      rating: map['rating'],
      notes: map['notes'],
    );
  }
}
