import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/widgets/plan_card.dart';
import 'package:pocket_travel_mobile/widgets/plan_header.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 5, // fetch plan data, and use planData.length + 1
          itemBuilder: (context, index) {
            if (index == 0) return const PlanHeader();
            return PlanCard();
          },
        ),
      ),
    );
  }
}
