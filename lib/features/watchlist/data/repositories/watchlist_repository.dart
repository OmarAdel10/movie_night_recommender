import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/movie_model.dart';

class WatchlistRepository {
  final FirebaseFirestore _firestore;

  WatchlistRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Movie>> getWatchlist(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> addMovie(String userId, Movie movie) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(movie.id.toString())
        .set(movie.toJson());
  }

  Future<void> removeMovie(String userId, int movieId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(movieId.toString())
        .delete();
  }
}
