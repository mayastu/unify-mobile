import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/course_material_model.dart';
import '../../data/models/material_download_status.dart';

class CourseMaterialCard extends StatelessWidget {
  const CourseMaterialCard({
    super.key,
    required this.material,
    required this.status,
    required this.onTap,
  });

  final CourseMaterialModel material;
  final MaterialDownloadStatus status;

  /// Tapping the card (or its trailing icon) always calls this — the
  /// cubit-driving parent decides what "tap" means for the current
  /// [status] (download vs. open vs. do nothing while in progress).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: status.stage == DownloadStage.downloading ? null : onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              material.fileExtension.isEmpty
                  ? '?'
                  : material.fileExtension.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: status.stage == DownloadStage.failed
                        ? Colors.red.shade400
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _TrailingIcon(status: status),
        ],
      ),
    );
  }

  String get _subtitle {
    switch (status.stage) {
      case DownloadStage.downloading:
        return 'Downloading… ${(status.progress * 100).toStringAsFixed(0)}%';
      case DownloadStage.downloaded:
        return 'Downloaded • tap to open';
      case DownloadStage.failed:
        return 'Download failed • tap to retry';
      case DownloadStage.none:
        return material.createdAt;
    }
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({required this.status});

  final MaterialDownloadStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status.stage) {
      case DownloadStage.downloading:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: status.progress > 0 ? status.progress : null,
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        );
      case DownloadStage.downloaded:
        return const Icon(
          Icons.open_in_new_rounded,
          color: AppColors.primary,
        );
      case DownloadStage.failed:
        return Icon(Icons.refresh_rounded, color: Colors.red.shade400);
      case DownloadStage.none:
        return const Icon(
          Icons.download_rounded,
          color: AppColors.textSecondary,
        );
    }
  }
}
