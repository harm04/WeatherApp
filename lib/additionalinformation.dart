import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInformation({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }
}
