import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/grade_breakdown_model.dart';
import 'grade_component_tile.dart';

class GradeSectionCard extends StatelessWidget {
  const GradeSectionCard({
    super.key,
    required this.section,
  });

  final GradeSectionBreakdownModel section;

  @override
  Widget build(BuildContext context) {
    final components = [...section.gradeComponents]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final myGrades = <int, StudentGradeItemModel>{
      for (final g
      in section.myEntry?.grades ?? const <StudentGradeItemModel>[])
        g.component.id: g,
    };

    final percentage = section.maxTotal > 0
        ? (section.earnedTotal / section.maxTotal).clamp(0.0, 1.0)
        : 0.0;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SectionHeader(
            section: section,
            percentage: percentage,
          ),

          if (components.isNotEmpty) ...[
            const Divider(
              height: 1,
              color: AppColors.border,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Column(
                children: [
                  ...components.map(
                        (component) => GradeComponentTile(
                      component: component,
                      gradeItem: myGrades[component.id],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.section,
    required this.percentage,
  });

  final GradeSectionBreakdownModel section;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final percent = (percentage * 100).round();

    final Color statusColor;

    if (percentage >= .6) {
      statusColor = Colors.green;
    } else if (percentage >= .4) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          // Circular score
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 6,
                    backgroundColor:
                    AppColors.primary.withOpacity(.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      statusColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'score',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sectionTitle(section.sectionType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Your current performance',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      _trim(section.earnedTotal),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ ${_trim(section.maxTotal)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sectionTitle(String value) {
    switch (value.toLowerCase()) {
      case 'theory':
        return 'Theory';
      case 'practical':
        return 'Practical';
      case 'project':
        return 'Project';
      default:
        return value;
    }
  }

  String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }
}