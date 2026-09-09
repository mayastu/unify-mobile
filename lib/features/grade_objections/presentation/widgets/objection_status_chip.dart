import 'package:flutter/material.dart';

class ObjectionStatusChip extends StatelessWidget {
  const ObjectionStatusChip({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            _label(status),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
      case 'resolved':
        return Colors.green;

      case 'rejected':
      case 'declined':
        return Colors.red;

      case 'pending':
      case 'under_review':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  String _label(String status) {
    if (status.isEmpty) {
      return 'Unknown';
    }

    return status
        .split('_')
        .map(
          (word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1),
    )
        .join(' ');
  }
}