// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      linkedInURL: json['linkedInURL'] as String?,
      shortDescription: json['shortDescription'] as String?,
      flutterExperience: $enumDecodeNullable(
          _$FlutterExperienceEnumMap, json['flutterExperience']),
      connections: (json['connections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'linkedInURL': instance.linkedInURL,
      'shortDescription': instance.shortDescription,
      'flutterExperience':
          _$FlutterExperienceEnumMap[instance.flutterExperience],
      'connections': instance.connections,
    };

const _$FlutterExperienceEnumMap = {
  FlutterExperience.none: 'none',
  FlutterExperience.beginner: 'beginner',
  FlutterExperience.intermediate: 'intermediate',
  FlutterExperience.advanced: 'advanced',
};
