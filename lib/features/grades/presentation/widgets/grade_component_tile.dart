import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../grade_objections/presentation/widgets/objection_sheet.dart';
import '../../data/models/grade_breakdown_model.dart';

/// One row inside a [GradeSectionCard]: a component's name plus the
/// student's score out of its max grade, with a small progress bar.
class GradeComponentTile extends StatelessWidget {
  const GradeComponentTile({super.key, required this.component, this.gradeItem});

  final GradeComponentModel component;

  /// Null when the instructor hasn't entered a score for this
  /// component yet (defined in the scheme, but not graded). Carries
  /// the grade entry's own `id`, which is what the objection
  /// endpoints key off — there's nothing to object to without it.
  final StudentGradeItemModel? gradeItem;

  @override
  Widget build(BuildContext context) {
    final grade = gradeItem?.grade;
    final maxGrade = component.maxGrade;
    final ratio = (grade != null && maxGrade > 0)
        ? (grade / maxGrade).clamp(0, 1).toDouble()
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  component.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                grade != null
                    ? '${_trim(grade)} / ${_trim(maxGrade)}'
                    : '— / ${_trim(maxGrade)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: grade != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (gradeItem != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => ObjectionSheet.show(
                    context,
                    studentGradeId: gradeItem!.id,
                    componentName: component.name,
                  ),
                  tooltip: 'Object to this grade',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: grade != null ? ratio : 0,
              minHeight: 6,
              backgroundColor: AppColors.background,
              color: grade == null
                  ? AppColors.border
                  : _colorFor(ratio),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(double ratio) {
    if (ratio >= 0.6) return Colors.green;
    if (ratio >= 0.4) return Colors.orange;
    return Colors.red;
  }

  String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }
}
