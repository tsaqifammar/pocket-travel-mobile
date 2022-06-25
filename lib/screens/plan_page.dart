
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (context.read<PlanProvider>().getPlans.isEmpty) {
        await PlanService(context).fetchPlans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: <Widget>() {
          List<Plan> plans = context.watch<PlanProvider>().getPlans;
          bool hasFetchedOnce = context.watch<PlanProvider>().hasFetchedOnce;

          if (!hasFetchedOnce) return const Center(child: CircularProgressIndicator());

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
