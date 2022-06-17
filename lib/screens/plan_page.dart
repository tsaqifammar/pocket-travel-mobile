
import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/providers/plan_provider.dart';
import 'package:pocket_travel_mobile/services/plan_service.dart';
import 'package:pocket_travel_mobile/widgets/plan_card.dart';
import 'package:pocket_travel_mobile/widgets/plan_header.dart';
import 'package:provider/provider.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await PlanService(context).fetchPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: <Widget>() {
          List<Plan> plans = context.watch<PlanProvider>().getPlans;

          if (plans.isEmpty) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: plans.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return const PlanHeader();
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: PlanCard(planData: plans[index-1]),
              );
            },
          );
        }(),
      ),
    );
  }
}
