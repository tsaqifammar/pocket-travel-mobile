import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/checklist.dart';
import 'package:pocket_travel_mobile/providers/checklist_provider.dart';
import 'package:pocket_travel_mobile/services/checklist_service.dart';
import 'package:pocket_travel_mobile/widgets/item_list.dart';
import 'package:provider/provider.dart';

class ChecklistPage extends StatefulWidget {
  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (context.read<ChecklistProvider>().getChecklist.isEmpty) {
        await ChecklistService(context).getAllChecklist();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: ItemList());
  }
}
