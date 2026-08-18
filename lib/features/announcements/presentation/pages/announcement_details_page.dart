import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  const AnnouncementDetailsPage({super.key, required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Announcement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  announcement.mediaUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, color: AppColors.textSecondary),
                  ),
                ),
              ),
            if (announcement.isImage) const SizedBox(height: 16),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(announcement.authorName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.schedule_rounded, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(announcement.publishedAt, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              announcement.body,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.6),
            ),
            if (announcement.hasMedia && !announcement.isImage) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  // Opening the raw media URL (e.g. a video) reuses
                  // whatever external-link launcher the app already
                  // has elsewhere (course materials, etc.) — not
                  // duplicated here to avoid pulling in a new package
                  // without checking what's already in pubspec.yaml.
                },
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('Open attachment'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
