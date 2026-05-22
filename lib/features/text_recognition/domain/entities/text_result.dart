import 'package:equatable/equatable.dart';

class TextResult extends Equatable {
  final String recognizedText;
  final List<String> lines;

  const TextResult({
    required this.recognizedText,
    required this.lines,
  });

  @override
  List<Object?> get props => [recognizedText, lines];
}
