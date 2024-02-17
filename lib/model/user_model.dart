import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? linkedInURL,
    String? shortDescription,
    FlutterExperience? flutterExperience,
    @Default([]) List<String> connections,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum FlutterExperience {
  none,
  beginner,
  intermediate,
  advanced,
}
