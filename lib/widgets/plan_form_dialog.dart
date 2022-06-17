import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:pocket_travel_mobile/models/schedule.dart';
import 'package:pocket_travel_mobile/services/plan_service.dart';
import 'package:pocket_travel_mobile/utils/status_snackbars.dart';
import 'package:pocket_travel_mobile/widgets/country_picker.dart';
import 'package:pocket_travel_mobile/widgets/date_picker.dart';
import 'package:pocket_travel_mobile/widgets/time_picker.dart';

class PlanFormDialog extends StatelessWidget {
  const PlanFormDialog({Key? key, this.initialPlan}) : super(key: key);

  final Plan? initialPlan;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          _PlanForm(initialPlan: initialPlan),
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
  const _PlanForm({Key? key, this.initialPlan}) : super(key: key);

  final Plan? initialPlan;

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

  // to be used in _ScheduleForm, let's just assume they share these infos.
  // don't think this way of managing states is ideal, but this will do for now.
  static int id = 0;
  static Map<int, Map<String, dynamic>> schedule = {};
  static void createScheduleRow({Schedule? initialValue}) {
    schedule[id] = {
      "time": (initialValue != null ? initialValue.time : "00:00"),
      "activity": TextEditingController(),
    };
    if (initialValue != null) {
      schedule[id]!['activity'].text = initialValue.activity;
    }
    id++;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      widget.initialPlan!.schedule.forEach((s) {
        createScheduleRow(initialValue: s);
      });
    }
  }

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
      _planData['schedule']
          .add({"time": value['time'], "activity": value['activity'].text});
    });
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
                initialValue: widget.initialPlan?.date.toString().split(' ')[0],
                onSaved: (value) {
                  _planData['date'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CountryPicker(
                initialValue: widget.initialPlan?.country,
                onSaved: (value) {
                  _planData['country'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.initialPlan?.name,
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
                    if (widget.initialPlan == null) {
                      await PlanService(context).createPlan(_planData);
                    } else {
                      await PlanService(context).editPlan(widget.initialPlan!.planId, _planData);
                    }
                    await PlanService(context).fetchPlans();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(StatusSnackBar.success('Success'));
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
  List<TableRow> _getScheduleRows() {
    List<TableRow> rows = [];
    __PlanFormState.schedule.forEach((i, value) {
      rows.add(TableRow(
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
                  primary: Colors.red, padding: const EdgeInsets.all(0)),
              onPressed: () {
                __PlanFormState.schedule.removeWhere((k, v) => k == i);
                setState(() {});
              },
              child: const Icon(Icons.cancel_outlined),
            ),
          )
        ],
      ));
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
              const Text(
                'Schedule',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  __PlanFormState.createScheduleRow();
                  setState(() {});
                },
                child: const Text('Add Item +'),
              ),
            ],
          ),
        ),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(32),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            const TableRow(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    child: Text('Time',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    child: Text('Activity',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    child: Text('')),
              ],
            ),
            ..._getScheduleRows(),
          ],
        ),
      ],
    );
  }
}
