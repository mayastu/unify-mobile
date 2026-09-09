import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../grade_objections/presentation/widgets/objection_sheet.dart';
import '../../data/models/grade_breakdown_model.dart';

class GradeComponentTile extends StatelessWidget {
  const GradeComponentTile({
    super.key,
    required this.component,
    this.gradeItem,
  });

  final GradeComponentModel component;
  final StudentGradeItemModel? gradeItem;

  @override
  Widget build(BuildContext context) {
    final grade = gradeItem?.grade;
    final maxGrade = component.maxGrade;

    final ratio = (grade != null && maxGrade > 0)
        ? (grade / maxGrade).clamp(0, 1).toDouble()
        : 0.0;

    final hasGrade = grade != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(.65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------
          // Header
          // ------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: hasGrade
                            ? _colorFor(ratio).withOpacity(.10)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        hasGrade
                            ? Icons.assignment_turned_in_rounded
                            : Icons.assignment_outlined,
                        size: 19,
                        color: hasGrade
                            ? _colorFor(ratio)
                            : AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        component.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Grade
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hasGrade
                        ? _trim(grade!)
                        : '—',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: hasGrade
                          ? _colorFor(ratio)
                          : AppColors.textSecondary,
                    ),
                  ),

                  Text(
                    '/ ${_trim(maxGrade)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ------------------------------------------------------------
          // Progress
          // ------------------------------------------------------------
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: hasGrade ? ratio : 0,
              minHeight: 7,
              backgroundColor: AppColors.border.withOpacity(.45),
              color: hasGrade
                  ? _colorFor(ratio)
                  : AppColors.border,
            ),
          ),

          const SizedBox(height: 10),

          // ------------------------------------------------------------
          // Bottom row
          // ------------------------------------------------------------
          Row(
            children: [
              Text(
                hasGrade
                    ? '${(ratio * 100).toStringAsFixed(0)}%'
                    : 'Not graded yet',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: hasGrade
                      ? _colorFor(ratio)
                      : AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              if (gradeItem != null)
                _ObjectionButton(
                  onPressed: () {
                    ObjectionSheet.show(
                      context,
                      studentGradeId: gradeItem!.id,
                      componentName: component.name,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorFor(double ratio) {
    if (ratio >= 0.60) return Colors.green;
    if (ratio >= 0.40) return Colors.orange;
    return Colors.red;
  }

  String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }
}

class _ObjectionButton extends StatelessWidget {
  const _ObjectionButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.flag_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              SizedBox(width: 5),
              Text(
                'Object',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}