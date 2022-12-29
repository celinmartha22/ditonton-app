import 'package:ditonton/common/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';
  group(
    'SSL Pinning HTTP',
    () {
      test(
        'Should get response 200 when success connect',
        () async {
          final _client = await Shared.createLEClient(isTestMode: true);
          final response = await _client
              .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
          expect(response.statusCode, 200);
        },
      );
    },
  );
}
