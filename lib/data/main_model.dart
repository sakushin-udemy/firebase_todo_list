import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_model.g.dart';
part 'main_model.freezed.dart';

@freezed
class MainModel with _$MainModel {
  const factory MainModel({
    @Default(false) bool visibleDoneItem,
    @Default(false) bool descending,
    @Default('') String newTodoTitle,
    @Default(0) int newTodoColor,
    DateTime? newTodoDateTime,
  }) = _MainModel;

  factory MainModel.fromJson(Map<String, dynamic> json) =>
      _$MainModelFromJson(json);
}
