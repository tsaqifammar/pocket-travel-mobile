
import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/services/plan_service.dart';
import 'package:pocket_travel_mobile/widgets/plan_card.dart';
import 'package:pocket_travel_mobile/widgets/plan_header.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  late Future<List<Plan>> plans;

  @override
  void initState() {
    super.initState();
    // TODO: Ambil userId dan token dari provider
    String userId = 'user-eW55sv5gJqujtWgO';
    String token = '62a476164223be28131a6ad3|4rlylsCIl7fQMaJMLqa4GyVMOasjr6xspwSxMmMG';
    plans = PlanService().fetchPlans(userId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FutureBuilder<List<Plan>>(
          future: plans,
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
