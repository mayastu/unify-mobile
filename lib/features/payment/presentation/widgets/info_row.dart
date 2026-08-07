import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.indigo,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              value.isEmpty ? "Not specified" : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}