import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'db_user.freezed.dart';
part 'db_user.g.dart';

@freezed
class DbUser with _$DbUser {
  const DbUser._(); //メソッド不要の場合、削除
  const factory DbUser({
    required String authenticationId,
    required String loginName,
    required String email,
    required String nickname,
  }) = _DbUser;

  factory DbUser.fromJson(Map<String, dynamic> json) => _$DbUserFromJson(json);
}
