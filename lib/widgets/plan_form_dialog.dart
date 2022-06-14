import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/screens/plan_page.dart';
import 'package:pocket_travel_mobile/services/plan_service.dart';
import 'package:pocket_travel_mobile/widgets/country_picker.dart';
import 'package:pocket_travel_mobile/widgets/date_picker.dart';
import 'package:pocket_travel_mobile/widgets/time_picker.dart';

class PlanFormDialog extends StatelessWidget {
  const PlanFormDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          const _PlanForm(),
          Positioned(
            right: 0,
            top: 0,
            child: InkResponse(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanForm extends StatefulWidget {
  const _PlanForm({Key? key}) : super(key: key);

  @override
  State<_PlanForm> createState() => __PlanFormState();
}

class __PlanFormState extends State<_PlanForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _planData = {
    "name": "",
    "date": "",
    "country": "",
    "schedule": []
  };
  static Map<int, Map<String, dynamic>> schedule = {};

  @override
  void dispose() {
    schedule.forEach((i, value) {
      schedule[i]!['activity'].dispose();
    });
    schedule = {};
    super.dispose();
  }

  void _saveSchedule() {
    schedule.forEach((i, value) {
      _planData['schedule'].add({
        "time": value['time'],
        "activity": value['activity'].text
      });
    });
  }

  Future<void> _createNewPlan() async {
    // TODO: Ambil userId dan token dari provider
    String userId = 'user-eW55sv5gJqujtWgO';
    String token = '62a476164223be28131a6ad3|4rlylsCIl7fQMaJMLqa4GyVMOasjr6xspwSxMmMG';
    await PlanService().createPlan(userId, token, _planData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Plan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DatePicker(
                onSaved: (value) {
                  _planData['date'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CountryPicker(
                onSaved: (value) {
                  _planData['country'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  icon: Icon(Icons.airplanemode_active),
                ),
                validator: (value) => (value == null || value.isEmpty
                    ? 'Please enter some text'
                    : null),
                onSaved: (value) {
                  _planData['name'] = value;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: _ScheduleForm(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveSchedule();
                    await _createNewPlan();
                    Navigator.of(context).pop();
                    await PlanPageState.fetchPlans();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ScheduleForm extends StatefulWidget {
  const _ScheduleForm({Key? key}) : super(key: key);

  @override
  State<_ScheduleForm> createState() => __ScheduleFormState();
}

class __ScheduleFormState extends State<_ScheduleForm> {
  int _id = 0;

  List<TableRow> _getScheduleRows() {
    List<TableRow> rows = [];
    __PlanFormState.schedule.forEach((i, value) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: TimePicker(
                value: __PlanFormState.schedule[i]!['time'],
                onChanged: (value) => setState(() {
                  __PlanFormState.schedule[i]!['time'] = value;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                controller: __PlanFormState.schedule[i]!['activity'],
                validator: (value) => (value == null || value.isEmpty
                    ? 'Please enter some text'
                    : null),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.all(0)
                ),
                onPressed: () {
                  __PlanFormState.schedule.removeWhere((k, v) => k == i);
                  setState(() {});
                },
                child: const Icon(Icons.cancel_outlined),
              ),
            )
          ],
        )
      );
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  __PlanFormState.schedule[_id++] = {
                    "time": "00:00",
                    "activity": TextEditingController(),
                  };
                  setState(() {});
                },
                child: const Text('Add Item +')
              ),
            ],
          ),
        ),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FixedColumnWidth(70),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(32),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  child: Text('Activity', style: TextStyle(fontWeight: FontWeight.bold))
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  child: Text('')
                ),
              ],
            ),
            ..._getScheduleRows(),
          ],
        ),
      ],
    );
  }
}
