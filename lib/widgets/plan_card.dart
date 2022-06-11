import 'package:flutter/material.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({Key? key}) : super(key: key);

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return const Text('card');
  }
}