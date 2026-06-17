import 'package:flutter_test/flutter_test.dart';
import 'package:movies/main.dart';
import 'package:provider/provider.dart';
import 'package:movies/providers/movie_provider.dart';

void main() {
  testWidgets('App smoke test - verifies login screen title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MovieProvider()),
        ],
        child: const MyMoviesApp(),
      ),
    );

    expect(find.text('MyMovies'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
