import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/text_result.dart';

part 'text_result_model.g.dart';

@JsonSerializable()
class TextResultModel extends TextResult {
  const TextResultModel({
    required super.recognizedText,
    required super.lines,
  });

  factory TextResultModel.fromJson(Map<String, dynamic> json) =>
      _$TextResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextResultModelToJson(this);
}
