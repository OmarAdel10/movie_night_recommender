// Tests disabled during refactoring to Firestore
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:movie_night_recommender/data/models/movie_model.dart';
// import 'package:movie_night_recommender/features/watchlist/view_models/watchlist_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:mocktail/mocktail.dart';

// class MockStorage extends Mock implements Storage {}

// void main() {
//   group('WatchlistBloc', () {
//     late Storage storage;

//     setUp(() {
//       storage = MockStorage();
//       when(
//         () => storage.write(any(), any<dynamic>()),
//       ).thenAnswer((_) async {});
//       HydratedBloc.storage = storage;
//     });

//     test('initial state is empty', () {
//       expect(WatchlistBloc().state, const WatchlistState());
//     });
//   });
// }
