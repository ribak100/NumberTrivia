import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivianumbers/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of number trivia entity', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when json number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('fromJson', () {
    test('should return a valid model when json number is regarded as a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a Json Map containing proper data', () async {
      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
