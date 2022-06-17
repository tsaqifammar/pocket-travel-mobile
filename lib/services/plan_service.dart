import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:pocket_travel_mobile/providers/plan_provider.dart';
import 'package:provider/provider.dart';

class PlanService {
  late BuildContext _context;
  late String userId, token;

  PlanService(BuildContext context) {
    _context = context;
    userId = _context.read<UserLoginProvider>().getUserId;
    token = _context.read<UserLoginProvider>().getToken;
  }

  Future<void> fetchPlans() async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(Uri.parse('${URLS.BACKEND}/plan/$userId'),
        headers: headers);

    if (response.statusCode == 200) {
      var resJson = jsonDecode(response.body);
      _context.read<PlanProvider>().setPlans(
          (resJson['plans'] as List).map((p) => Plan.fromJson(p)).toList());
    } else {
      throw Exception('Fetching plan failed');
    }
  }

  Future<void> createPlan(Map<String, dynamic> data) async {
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
