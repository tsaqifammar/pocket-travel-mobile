import 'package:flutter/cupertino.dart';
import 'package:pocket_travel_mobile/models/checklist.dart';

class ChecklistProvider with ChangeNotifier {
  List<Checklist> _checklist = [];

  List<Checklist> get getChecklist {
    return _checklist;
  }

  void setChecklist(List<Checklist> cl) {
    _checklist = cl;
    notifyListeners();
  }
}
