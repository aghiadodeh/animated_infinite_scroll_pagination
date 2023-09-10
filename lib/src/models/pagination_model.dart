import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class PaginationModel<T> extends Equatable {
  final String id;
  final T item;
  final int page;

  const PaginationModel({
    required this.id,
    required this.item,
    required this.page,
  });

  @override
  List<Object?> get props => [id];
}

String randomString() {
  return "${const Uuid().v4()}-${DateTime.now()}";
}
