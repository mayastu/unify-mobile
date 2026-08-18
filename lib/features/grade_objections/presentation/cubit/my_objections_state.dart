import '../../data/models/grade_objection_model.dart';

abstract class MyObjectionsState {
  const MyObjectionsState({this.items = const []});

  final List<GradeObjectionModel> items;
}

class MyObjectionsLoading extends MyObjectionsState {
  const MyObjectionsLoading();
}

class MyObjectionsLoadingMore extends MyObjectionsState {
  const MyObjectionsLoadingMore({required super.items, required this.hasMore});

  final bool hasMore;
}

class MyObjectionsLoaded extends MyObjectionsState {
  const MyObjectionsLoaded({required super.items, required this.hasMore});

  final bool hasMore;
}

class MyObjectionsFailure extends MyObjectionsState {
  const MyObjectionsFailure(this.message, {super.items});

  final String message;
}
