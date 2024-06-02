// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      name: json['name'] as String? ?? '',
      text: json['text'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'time': instance.time,
    };
