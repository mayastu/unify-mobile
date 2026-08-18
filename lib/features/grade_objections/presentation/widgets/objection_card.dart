import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/grade_objection_model.dart';
import 'objection_status_chip.dart';

class ObjectionCard extends StatelessWidget {
  const ObjectionCard({super.key, required this.objection});

  final GradeObjectionModel objection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${objection.course.name} • ${objection.gradeComponent.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ObjectionStatusChip(status: objection.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            objection.details,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          if (objection.responseNote.isNotEmpty) ...[
            const Divider(height: 20),
            Text(
              'Response',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              objection.responseNote,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (objection.currentGrade != null)
                Text(
                  'Current: ${_trim(objection.currentGrade!)} / '
                  '${_trim(objection.gradeComponent.maxGrade)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              Text(
                objection.submittedAt,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }
}
