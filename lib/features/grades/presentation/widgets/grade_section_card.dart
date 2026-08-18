import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/grade_breakdown_model.dart';
import 'grade_component_tile.dart';

/// Renders one section-type's worth of grade components (already
/// ordered by `display_order`) with the student's earned/max total
/// on top.
class GradeSectionCard extends StatelessWidget {
  const GradeSectionCard({super.key, required this.section});

  final GradeSectionBreakdownModel section;

  @override
  Widget build(BuildContext context) {
    final components = [...section.gradeComponents]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final myGrades = <int, StudentGradeItemModel>{
      for (final g in section.myEntry?.grades ?? const <StudentGradeItemModel>[])
        g.component.id: g,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${_trim(section.earnedTotal)} / ${_trim(section.maxTotal)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...components.map(
            (component) => GradeComponentTile(
              component: component,
              gradeItem: myGrades[component.id],
            ),
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
