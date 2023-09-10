import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

class PaginationModel<T extends Object> extends Equatable {
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
