import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivianumbers/core/error/exceptions.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/core/network/network_info.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:trivianumbers/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';
//import 'package:trivianumbers/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });

  void runTestOnline(Function body){
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });
      body();
 });
    }

    void runTestOffline(Function body){
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      body();
 });
    }

  group('get concrete number trivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test Trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () async{
      //arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(()=> mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


      //act
      await repository!.getConcreteNumberTrivia(1);
      //assert
      verify(() => mockNetworkInfo!.isConnected);
    });

    runTestOnline( () {


      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });


      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
         when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});

        //act
         await repository!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
          verify(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            //arrange
            when(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
                .thenThrow(ServerException());
            when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


            //act
            final result = await repository!.getConcreteNumberTrivia(tNumber);

            //assert
            verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
            expect(result, Left(ServerFailure()));
          });

    });

    runTestOffline( () {

    test('return last locally catch data when the cache data is present', () async{
        //arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() =>mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));

      });

      test('should retuen CacheFailure when there is no cache data is present', () async{
        //arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia()).thenThrow(CacheException());

        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() =>mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));

      });

    });
  });

  group('get Random number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test Trivia', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () async{
      //arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(()=> mockRemoteDataSource!.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


      //act
      await repository!.getRandomNumberTrivia();
      //assert
      verify(() => mockNetworkInfo!.isConnected);
    });

    runTestOnline( () {


      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


        //act
        final result = await repository!.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });


      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
         when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});

        //act
         await repository!.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
          verify(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            //arrange
            when(() => mockRemoteDataSource!.getRandomNumberTrivia())
                .thenThrow(ServerException());
            when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async {});


            //act
            final result = await repository!.getRandomNumberTrivia();

            //assert
            verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
            expect(result, Left(ServerFailure()));
          });

    });

    runTestOffline( () {

    test('return last locally catch data when the cache data is present', () async{
        //arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository!.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() =>mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));

      });

      test('should return CacheFailure when there is no cache data is present', () async{
        //arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia()).thenThrow(CacheException());

        //act
        final result = await repository!.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() =>mockLocalDataSource!.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));

      });

    });
  });
}
