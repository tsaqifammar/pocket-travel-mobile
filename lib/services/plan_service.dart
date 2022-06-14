
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';

class PlanService {
  Future<List<Plan>> fetchPlans(String userId, String token) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(Uri.parse('${URLS.BACKEND}/plan/$userId'), headers: headers);

    if (response.statusCode == 200) {
      var resJson = jsonDecode(response.body);
      return (resJson['plans'] as List).map((p) => Plan.fromJson(p)).toList();
    } else {
      throw Exception('Fetching plan failed');
    }
  }

  Future<void> createPlan(String userId, String token, Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.post(
      Uri.parse('${URLS.BACKEND}/plan/$userId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Creating plan failed');
    }
  }
}
