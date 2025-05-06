import 'package:http/http.dart' as http;

class ApiClient {
  dynamic request(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response;
    } catch (e) {
      print(e);
    }
  }
}
