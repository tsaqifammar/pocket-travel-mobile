import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_travel_mobile/models/checklist.dart';
import 'package:pocket_travel_mobile/providers/checklist_provider.dart';
import 'package:pocket_travel_mobile/providers/user_login_provider.dart';
import 'package:pocket_travel_mobile/utils/urls.dart';
import 'package:provider/provider.dart';

class ChecklistService {
  late BuildContext _context;
  late String userId, token;

  ChecklistService(BuildContext context) {
    _context = context;
    userId = _context.read<UserLoginProvider>().getUserId;
    token = _context.read<UserLoginProvider>().getToken;
  }

  Future<void> getAllChecklist() async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http
        .get(Uri.parse('${URLS.BACKEND}/checklist/$userId'), headers: headers);

    if (response.statusCode == 200) {
      var resJson = jsonDecode(response.body);
      _context.read<ChecklistProvider>().setChecklist(
          (resJson['itemList'] as List)
              .map((p) => Checklist.fromJson(p))
              .toList());
    } else {
      throw Exception('Fetching checklist failed');
    }
  }

  Future<void> createChecklist(Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
        Uri.parse('${URLS.BACKEND}/checklist/$userId'),
        headers: headers,
        body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to post checklist');
    }
  }

  Future<void> deleteChecklist(String itemId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.delete(
        Uri.parse('${URLS.BACKEND}/checklist/$itemId'),
        headers: headers);

    if (response.statusCode != 200) throw "Failed to delete a checklist.";
  }
}
