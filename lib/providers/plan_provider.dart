
import 'package:flutter/cupertino.dart';
import 'package:pocket_travel_mobile/models/plan.dart';

class PlanProvider with ChangeNotifier {
  List<Plan> _plans = [];
  bool _fetchedOnce = false;

  List<Plan> get getPlans {
    return _plans;
  }

  bool get hasFetchedOnce {
    return _fetchedOnce;
  }

  void setPlans(List<Plan> ps) {
    _plans = ps;
    notifyListeners();
  }

  void setFetchedOnce(bool fo) {
    _fetchedOnce = fo;
  }
}
