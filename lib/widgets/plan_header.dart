import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/widgets/plan_form_dialog.dart';

class PlanHeader extends StatelessWidget {
  const PlanHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const PlanFormDialog(),
              );
            },
            child: const Text('Create +')
          ),
        ],
      ),
    );
  }
}