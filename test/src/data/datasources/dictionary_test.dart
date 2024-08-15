import 'package:coodesh/src/data/datasources/dictionary.dart';
import 'package:coodesh/src/domain/entities/word_entity.dart';
import 'package:coodesh/src/domain/exceptions/dictionary.dart';
import 'package:coodesh/src/http/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);

  dio.httpClientAdapter = dioAdapter;
  group('Raw response', () {
    group('- Success case', () {
      const path = '$baseUrl/hello';

      dioAdapter.onGet(
        path,
        (request) => request.reply(200, json),
      );

      test('Expect json as response when statusCode 200', () async {
        final response = await dio.get(path);

        expect(response.statusCode, equals(200));
        expect(response.data, equals(json));
      });
    });
    group('- Failure case', () {
      const path = '$baseUrl/hellow';
      dioAdapter.onGet(
          path,
          (request) => request.throws(
                404,
                DioException(
                    requestOptions: RequestOptions(),
                    response: Response(
                      requestOptions: RequestOptions(),
                      data: errorJson,
                    )),
              ));

      test('Expect error json when statusCode 404', () async {
        final response = await dio.get(path);

        expect(response.statusCode, equals(404));
        expect(response.data, equals(errorJson));
      });
    });
  });

  group('Datasource', () {
    group('- Success case', () {
      dioAdapter.onGet(
        '$baseUrl/hello',
        (request) => request.reply(200, json),
      );
      test('Expect WordEntity from datasource when statusCode 200', () async {
        final response = await DictionaryImpl(
          client: dio,
        ).getWordDetails('hello');
        expect(
          response,
          equals(
            WordEntity(
              word: "hello",
              audioUrl:
                  "https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3",
              meanings: [
                WordMeaningEntity(
                  partOfSpeech: "noun",
                  definition: "\"Hello!\" or an equivalent greeting.",
                ),
                WordMeaningEntity(
                  partOfSpeech: "verb",
                  definition: "To greet with \"hello\".",
                ),
                WordMeaningEntity(
                  partOfSpeech: "interjection",
                  definition:
                      "A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.",
                ),
              ],
            ),
          ),
        );
      });
    });
    group('- Failure case', () {
      dioAdapter.onGet(
        '$baseUrl/hellow',
        (request) => request.reply(404, errorJson),
      );

      test('Expect DictionaryException from datasource when statusCode != 200',
          () async {
        final response = await DictionaryImpl(
          client: dio,
        ).getWordDetails('hellow');

        expect(response, throwsA(isA<DictionaryException>()));
      });
    });
  });
}

final json = [
  {
    "word": "hello",
    "phonetics": [
      {
        "audio":
            "https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3",
        "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=75797336",
        "license": {
          "name": "BY-SA 4.0",
          "url": "https://creativecommons.org/licenses/by-sa/4.0"
        }
      },
      {
        "text": "/həˈləʊ/",
        "audio":
            "https://api.dictionaryapi.dev/media/pronunciations/en/hello-uk.mp3",
        "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=9021983",
        "license": {
          "name": "BY 3.0 US",
          "url": "https://creativecommons.org/licenses/by/3.0/us"
        }
      },
      {"text": "/həˈloʊ/", "audio": ""}
    ],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          {
            "definition": "\"Hello!\" or an equivalent greeting.",
            "synonyms": [],
            "antonyms": []
          }
        ],
        "synonyms": ["greeting"],
        "antonyms": []
      },
      {
        "partOfSpeech": "verb",
        "definitions": [
          {
            "definition": "To greet with \"hello\".",
            "synonyms": [],
            "antonyms": []
          }
        ],
        "synonyms": [],
        "antonyms": []
      },
      {
        "partOfSpeech": "interjection",
        "definitions": [
          {
            "definition":
                "A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.",
            "synonyms": [],
            "antonyms": [],
            "example": "Hello, everyone."
          },
          {
            "definition": "A greeting used when answering the telephone.",
            "synonyms": [],
            "antonyms": [],
            "example": "Hello? How may I help you?"
          },
          {
            "definition":
                "A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.",
            "synonyms": [],
            "antonyms": [],
            "example": "Hello? Is anyone there?"
          },
          {
            "definition":
                "Used sarcastically to imply that the person addressed or referred to has done something the speaker or writer considers to be foolish.",
            "synonyms": [],
            "antonyms": [],
            "example":
                "You just tried to start your car with your cell phone. Hello?"
          },
          {
            "definition": "An expression of puzzlement or discovery.",
            "synonyms": [],
            "antonyms": [],
            "example": "Hello! What’s going on here?"
          }
        ],
        "synonyms": [],
        "antonyms": ["bye", "goodbye"]
      }
    ],
    "license": {
      "name": "CC BY-SA 3.0",
      "url": "https://creativecommons.org/licenses/by-sa/3.0"
    },
    "sourceUrls": ["https://en.wiktionary.org/wiki/hello"]
  }
];

final errorJson = {
  "title": "No Definitions Found",
  "message":
      "Sorry pal, we couldn't find definitions for the word you were looking for.",
  "resolution":
      "You can try the search again at later time or head to the web instead."
};
