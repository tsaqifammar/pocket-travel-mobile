
import 'package:flutter/material.dart';

class CountryPicker extends StatelessWidget {
  const CountryPicker({Key? key, this.onSaved}) : super(key: key);

  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>['one', 'two']
          .map<DropdownMenuItem<String>>(
              (value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Country',
        icon: Icon(Icons.flag),
      ),
      validator: (value) =>
          (value == null || value.isEmpty ? 'Please select a country' : null),
      onChanged: (value) {},
      onSaved: onSaved,
    );
  }
}
