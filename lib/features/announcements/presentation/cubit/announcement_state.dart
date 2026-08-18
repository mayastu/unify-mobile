import '../../data/models/announcement_model.dart';

abstract class AnnouncementState {
  const AnnouncementState({
    this.items = const [],
    this.hasMore = true,
  });

  final List<AnnouncementModel> items;
  final bool hasMore;
}

class AnnouncementInitial extends AnnouncementState {
  const AnnouncementInitial();
}

class AnnouncementLoading extends AnnouncementState {
  const AnnouncementLoading();
}

class AnnouncementLoadingMore extends AnnouncementState {
  const AnnouncementLoadingMore({
    required super.items,
    required super.hasMore,
  });
}

class AnnouncementLoaded extends AnnouncementState {
  const AnnouncementLoaded({
    required super.items,
    required super.hasMore,
  });
}

class AnnouncementFailure extends AnnouncementState {
  const AnnouncementFailure(this.message, {super.items});

  final String message;
}
