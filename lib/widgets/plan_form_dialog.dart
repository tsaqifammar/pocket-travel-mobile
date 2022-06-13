import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/widgets/country_picker.dart';
import 'package:pocket_travel_mobile/widgets/date_picker.dart';

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
    "schedule": [],
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print(_planData.toString());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
