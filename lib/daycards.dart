import 'package:flutter/material.dart';

class DayCards extends StatelessWidget {
  final String time;
  final String date;
  final IconData icon;
  final double temperature;
  const DayCards({super.key, required this.icon, required this.date, required this.time, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color(0xFF464343),
        ),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 05),
              child: Text(
                time,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                date,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                temperature.toStringAsFixed(1) + '°C',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
