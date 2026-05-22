// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextResultModel _$TextResultModelFromJson(Map<String, dynamic> json) =>
    TextResultModel(
      recognizedText: json['recognizedText'] as String,
      lines: (json['lines'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TextResultModelToJson(TextResultModel instance) =>
    <String, dynamic>{
      'recognizedText': instance.recognizedText,
      'lines': instance.lines,
    };
