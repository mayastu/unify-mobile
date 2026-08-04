import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/classroom_cubit.dart';
import '../cubit/classroom_state.dart';
import '../widgets/classroom_card.dart';

class ClassroomsPage extends StatelessWidget {
  const ClassroomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Classrooms'),
      ),
      body: BlocBuilder<ClassroomCubit, ClassroomState>(
        builder: (context, state) {
          if (state is ClassroomLoading || state is ClassroomInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClassroomFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<ClassroomCubit>().getClassrooms(),
            );
          }

          final classrooms = (state as ClassroomSuccess).classrooms;

          if (classrooms.isEmpty) {
            return const AppEmpty(
              icon: Icons.meeting_room_outlined,
              message: 'No classrooms found.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ClassroomCubit>().getClassrooms(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: classrooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  ClassroomCard(classroom: classrooms[index]),
            ),
          );
        },
      ),
    );
  }
}
