import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivianumbers/core/error/exceptions.dart';

import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:trivianumbers/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}



void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  void setTheMock(dynamic body, int statusCode){
    when(() => mockHttpClient!.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(body, statusCode));
  }

  setUp(() {
    registerFallbackValue(Uri());
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a get request on a URL with number being the 
    endpoint and with application/json header''', () async {
      //arrange
      setTheMock(fixture('trivia.json'), 200);
      //act
      dataSource!.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('''should return numberTrivia if responseCode is 200(success)''',
        () async {
      //arrange
          setTheMock(fixture('trivia.json'), 200);

      //act
      final result = await dataSource!.getConcreteNumberTrivia(tNumber);
      //assert

      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throw a ServerException if responseCode is not successful''',
        () async {
      //arrange
          setTheMock('Something went wrong', 404);
      //act
      final call =  dataSource!.getConcreteNumberTrivia;
      //assert

      expect(call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a get request on a URL with number being the 
    endpoint and with application/json header''', () async {
      //arrange
      setTheMock(fixture('trivia.json'), 200);
      //act
      dataSource!.getRandomNumberTrivia();
      //assert
      verify(() => mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('''should return numberTrivia if responseCode is 200(success)''',
        () async {
      //arrange
          setTheMock(fixture('trivia.json'), 200);

      //act
      final result = await dataSource!.getRandomNumberTrivia();
      //assert

      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throw a ServerException if responseCode is not successful''',
        () async {
      //arrange
          setTheMock('Something went wrong', 404);
      //act
      final call =  dataSource!.getRandomNumberTrivia();
      //assert

      expect(call, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
