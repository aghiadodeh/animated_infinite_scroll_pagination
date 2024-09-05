import '../../utils/unique_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'pagination_model.freezed.dart';

@Freezed(genericArgumentFactories: true)
class PaginationModel<T> with _$PaginationModel<T> {
  const factory PaginationModel({
    required String id,
    required T item,
    required int page,
  }) = _PaginationModel<T>;

  factory PaginationModel.fromItem(T item, int page) {
    return PaginationModel(id: randomId, item: item, page: page);
  }
}
