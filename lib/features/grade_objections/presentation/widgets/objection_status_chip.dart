import 'package:flutter/material.dart';

/// Status values are backend-defined strings (e.g. 'pending',
/// 'approved', 'rejected'); anything unrecognized falls back to a
/// neutral grey chip instead of crashing or guessing.
class ObjectionStatusChip extends StatelessWidget {
  const ObjectionStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
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
    if (status.isEmpty) return 'Unknown';
    return status
        .split('_')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}
