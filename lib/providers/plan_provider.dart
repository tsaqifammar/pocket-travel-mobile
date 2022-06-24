
import 'package:flutter/cupertino.dart';
import 'package:pocket_travel_mobile/models/plan.dart';

class PlanProvider with ChangeNotifier {
  List<Plan> _plans = [];

  List<Plan> get getPlans {
    return _plans;
  }

  void setPlans(List<Plan> ps) {
    _plans = ps;
    notifyListeners();
  }
}
