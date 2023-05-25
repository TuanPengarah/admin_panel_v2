import 'package:flutter/material.dart';

class RadioTile extends StatelessWidget {
  final String label;
  final bool value;
  final bool groupValue;
  final Function onChanged;

  const RadioTile(
      {super.key, required this.label,
      required this.value,
      required this.groupValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
      child: InkWell(
        onTap: () {
          if (value != groupValue) {
            onChanged(value);
          }
        },
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
