import 'package:http/http.dart' as http;

Future GetData(url) async {
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('server side error');
  }
  // return response;
}
