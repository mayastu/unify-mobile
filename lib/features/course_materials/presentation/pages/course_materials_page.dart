import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/course_material_model.dart';
import '../../data/models/material_download_status.dart';
import '../cubit/course_material_cubit.dart';
import '../cubit/course_material_state.dart';
import '../widgets/course_material_card.dart';

class CourseMaterialsPage extends StatefulWidget {
  const CourseMaterialsPage({
    super.key,
    required this.courseSectionId,
    required this.title,
  });

  final int courseSectionId;
  final String title;

  @override
  State<CourseMaterialsPage> createState() => _CourseMaterialsPageState();
}

class _CourseMaterialsPageState extends State<CourseMaterialsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CourseMaterialCubit>().load(widget.courseSectionId);
  }

  Future<void> _handleTap(CourseMaterialModel material, MaterialDownloadStatus status) async {
    final cubit = context.read<CourseMaterialCubit>();

    if (status.stage == DownloadStage.downloaded) {
      try {
        await cubit.open(material);
      } catch (e) {
        if (mounted) AppSnackBar.error(context, e.toString());
      }
      return;
    }

    await cubit.download(material);

    final latest = cubit.state;
    if (latest is! CourseMaterialLoaded) return;

    final newStatus = latest.downloads[material.id];
    if (newStatus?.stage == DownloadStage.downloaded) {
      try {
        await cubit.open(material);
      } catch (e) {
        if (mounted) AppSnackBar.error(context, e.toString());
      }
    } else if (newStatus?.stage == DownloadStage.failed) {
      if (mounted) {
        AppSnackBar.error(context, newStatus?.error ?? 'Download failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<CourseMaterialCubit, CourseMaterialState>(
        builder: (context, state) {
          if (state is CourseMaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseMaterialFailure && state.items.isEmpty) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<CourseMaterialCubit>().load(widget.courseSectionId),
            );
          }

          if (state.items.isEmpty) {
            return const AppEmpty(
              icon: Icons.folder_off_outlined,
              message: 'No materials uploaded for this section yet.',
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<CourseMaterialCubit>().load(widget.courseSectionId),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final material = state.items[index];
                final status =
                    state.downloads[material.id] ?? const MaterialDownloadStatus.none();

                return CourseMaterialCard(
                  material: material,
                  status: status,
                  onTap: () => _handleTap(material, status),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
