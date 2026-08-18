import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/grade_objection_repository.dart';
import 'my_objections_state.dart';

class MyObjectionsCubit extends Cubit<MyObjectionsState> {
  final GradeObjectionRepository repository;

  static const _perPage = 20;
  int _page = 1;

  MyObjectionsCubit(this.repository) : super(const MyObjectionsLoading());

  Future<void> load({bool refresh = true}) async {
    if (refresh) {
      _page = 1;
      emit(const MyObjectionsLoading());
    }

    try {
      final result = await repository.getMyObjections(
        page: _page,
        perPage: _perPage,
      );

      emit(MyObjectionsLoaded(
        items: refresh ? result.items : [...state.items, ...result.items],
        hasMore: _page < result.lastPage,
      ));
    } catch (e) {
      emit(MyObjectionsFailure(e.toString(), items: state.items));
    }
  }

  Future<void> loadMore() async {
    if (state is! MyObjectionsLoaded) return;

    final current = state as MyObjectionsLoaded;
    if (!current.hasMore) return;

    emit(MyObjectionsLoadingMore(items: current.items, hasMore: current.hasMore));

    _page++;

    try {
      final result = await repository.getMyObjections(
        page: _page,
        perPage: _perPage,
      );

      emit(MyObjectionsLoaded(
        items: [...current.items, ...result.items],
        hasMore: _page < result.lastPage,
      ));
    } catch (_) {
      _page--;

      // Keep what's already on screen; the user can just scroll again.
      emit(MyObjectionsLoaded(items: current.items, hasMore: current.hasMore));
    }
  }
}
