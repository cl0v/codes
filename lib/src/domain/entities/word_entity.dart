import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String word;
  final String audioUrl;
  final List<WordMeaningEntity> meanings;

  WordEntity({
    required this.word,
    required this.audioUrl,
    required this.meanings,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [word, audioUrl, meanings];
}

class WordMeaningEntity extends Equatable {
  final String partOfSpeech;
  final String definition;

  WordMeaningEntity({
    required this.partOfSpeech,
    required this.definition,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [partOfSpeech, definition];
}
