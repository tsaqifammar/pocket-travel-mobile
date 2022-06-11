import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({Key? key, required this.planData}) : super(key: key);

  final Plan planData;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.planData.toJson().toString());
  }
}