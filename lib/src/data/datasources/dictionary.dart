import 'package:coodesh/src/data/mappers/word_mapper.dart';
import 'package:coodesh/src/domain/entities/word_entity.dart';
import 'package:coodesh/src/http/endpoints.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/dictionary.dart';

abstract class IDictionary {
  Future getWordDetails(String word);
}

class DictionaryImpl implements IDictionary {
  final Dio client;

  DictionaryImpl({required this.client});

  @override
  Future<WordEntity> getWordDetails(String word) async {
    try {
      final response = await client.get('$baseUrl/$word');
      return WordMapper.map(response.data);
    } on DioException catch (ex) {
      throw DictionaryException(
        statusCode: ex.response?.statusCode,
        message: ex.response?.data,
      );
    }
  }
}
