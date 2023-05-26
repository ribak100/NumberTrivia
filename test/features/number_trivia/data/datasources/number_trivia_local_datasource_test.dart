import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivianumbers/core/error/exceptions.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return numberTrivia from SharedPreferences when there is one in a cache',
        () async {
      //arrange
      when(() => mockSharedPreferences!.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      //act

      final result = await dataSource!.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences!.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });


    test(
        'should throw a CacheException when there is no cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences!.getString(any()))
          .thenReturn(null);
      //act

      //assert
      expect(() => dataSource!.getLastNumberTrivia(), throwsA(const TypeMatcher<CacheException>()));
    });


  });
  
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
    final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

    test('should call sharedPreferences to cache the data', ()
    async{
      //arrange
      when(() => mockSharedPreferences!.setString(cachedNumberTrivia, any())).thenAnswer((_) async => true);
      //act
      dataSource!.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      verify(() => mockSharedPreferences!.setString(cachedNumberTrivia, expectedJsonString));
    });

  });
}

