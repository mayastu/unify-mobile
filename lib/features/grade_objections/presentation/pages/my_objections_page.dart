import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/my_objections_cubit.dart';
import '../cubit/my_objections_state.dart';
import '../widgets/objection_card.dart';

class MyObjectionsPage extends StatefulWidget {
  const MyObjectionsPage({super.key});

  @override
  State<MyObjectionsPage> createState() => _MyObjectionsPageState();
}

class _MyObjectionsPageState extends State<MyObjectionsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MyObjectionsCubit>().load();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MyObjectionsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('My Objections'),
      ),
      body: BlocBuilder<MyObjectionsCubit, MyObjectionsState>(
        builder: (context, state) {
          if (state is MyObjectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyObjectionsFailure && state.items.isEmpty) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () => context.read<MyObjectionsCubit>().load(),
            );
          }

          if (state.items.isEmpty) {
            return const AppEmpty(
              icon: Icons.gavel_rounded,
              message: 'You haven\'t submitted any grade objections yet.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<MyObjectionsCubit>().load(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount:
                  state.items.length + (state is MyObjectionsLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return ObjectionCard(objection: state.items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
