import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocket_travel_mobile/models/checklist.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';

class ApiService {
  Future<List<Checklist>> getChecklist(String userId, String token) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http
        .get(Uri.parse('${URLS.BACKEND}/checklist/$userId'), headers: headers);

    if (response.statusCode == 200) {
      var resJson = jsonDecode(response.body);
      return (resJson['checklist'] as List)
          .map((p) => Checklist.fromJson(p))
          .toList();
    } else {
      throw Exception('Fetching checklist failed');
    }
  }

  Future<Checklist> createChecklist(
      Checklist checklist, String userId, String token) async {
    Map data = {
      'name': checklist.name,
      'is_checked': checklist.is_checked,
    };

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
        Uri.parse('${URLS.BACKEND}/checklist/$userId'),
        headers: headers,
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      return Checklist.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post checklist');
    }
  }

  Future<void> deleteChecklist(
      String itemId, String userId, String token) async {
    final response =
        await http.delete(Uri.parse('${URLS.BACKEND}/checklist/$itemId'));

    if (response.statusCode == 200) {
      print("Checklist deleted");
    } else {
      throw "Failed to delete a checklist.";
    }
  }
}
