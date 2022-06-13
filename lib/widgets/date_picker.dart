
import 'package:flutter/material.dart';

/// A DatePicker widget.
/// Basically a text field, that is if pressed, will run showDatePicker().
/// Once a date is picked, the text field will be filled with that selected date.
class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, this.initialValue = '', this.onSaved}) : super(key: key);

  final String initialValue;
  final void Function(String?)? onSaved;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _controller = TextEditingController();
  // To unfocus the "text field" once a date is selected
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _controller.text = widget.initialValue;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: focusNode,
      decoration: const InputDecoration(
        labelText: 'Date',
        icon: Icon(Icons.calendar_month),
      ),
      validator: (value) => (value == null || value.isEmpty
          ? 'Please select a date'
          : null),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 100)
        ).then((value) {
          _controller.text = value.toString().split(' ')[0];
        });
        focusNode.unfocus();
      },
      onSaved: widget.onSaved,
    );
  }
}