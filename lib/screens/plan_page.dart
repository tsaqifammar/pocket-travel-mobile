
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/services/plan_service.dart';
import 'package:pocket_travel_mobile/widgets/plan_card.dart';
import 'package:pocket_travel_mobile/widgets/plan_header.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => PlanPageState();
}

class PlanPageState extends State<PlanPage> {
  static late StreamController<List<Plan>?> _events;

  @override
  void initState() {
    super.initState();
    _events = StreamController();
    fetchPlans();
  }

  static Future<void> fetchPlans() async {
    try {
      // TODO: Ambil userId dan token dari provider
      String userId = 'user-eW55sv5gJqujtWgO';
      String token = '62a476164223be28131a6ad3|4rlylsCIl7fQMaJMLqa4GyVMOasjr6xspwSxMmMG';
      List<Plan> res = await PlanService().fetchPlans(userId, token);
      _events.add(res);
    } catch (e) {
      // mungkin tampilin snackbar itu
      print('fetching plan failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: StreamBuilder<List<Plan>?>(
          stream: _events.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var plansData = snapshot.data!;
              return ListView.builder(
                itemCount: plansData.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const PlanHeader();
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: PlanCard(planData: plansData[index-1]),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
