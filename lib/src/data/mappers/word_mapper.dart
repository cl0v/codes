import 'package:coodesh/src/domain/entities/word_entity.dart';

class WordMapper {
  static WordEntity map(List w) {
    final data = w[0];
    final word = data["word"];
    final audioUrl = data["phonetics"][0]["audio"];
    final meanings = (data["meanings"] as List)
        .map<WordMeaningEntity>((e) => WordMeaningEntity(
              partOfSpeech: e["partOfSpeech"],
              definition: (e["definitions"] as List)[0]["definition"]
            ))
        .toList();

    return WordEntity(word: word, audioUrl: audioUrl, meanings: meanings);
  }
}
