import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/announcement_repository.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository repository;

  static const _perPage = 20;
  int _page = 1;

  AnnouncementCubit(this.repository) : super(const AnnouncementInitial());

  Future<void> getAnnouncements({bool refresh = true}) async {
    if (refresh) {
      _page = 1;
      emit(const AnnouncementLoading());
    }

    try {
      final result = await repository.getAnnouncements(
        page: _page,
        perPage: _perPage,
      );

      emit(AnnouncementLoaded(
        items: refresh ? result.items : [...state.items, ...result.items],
        hasMore: _page < result.lastPage,
      ));
    } catch (e) {
      emit(AnnouncementFailure(e.toString(), items: state.items));
    }
  }

  Future<void> loadMore() async {
    if (state is! AnnouncementLoaded) return;

    final current = state as AnnouncementLoaded;
    if (!current.hasMore) return;

    emit(AnnouncementLoadingMore(items: current.items, hasMore: current.hasMore));

    _page++;

    try {
      final result = await repository.getAnnouncements(
        page: _page,
        perPage: _perPage,
      );

      emit(AnnouncementLoaded(
        items: [...current.items, ...result.items],
        hasMore: _page < result.lastPage,
      ));
    } catch (_) {
      _page--;

      // Keep the list the user already sees intact; they can just
      // scroll again to retry "load more".
      emit(AnnouncementLoaded(items: current.items, hasMore: current.hasMore));
    }
  }
}
