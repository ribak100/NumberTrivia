import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivianumbers/core/error/exceptions.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/core/usecase/usecase.dart';
import 'package:trivianumbers/core/util/input_converter.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class MockBloc extends Mock implements NumberTriviaBloc{}

void main() {
  NumberTriviaBloc? bloc;
  MockBloc? mockBloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;


  setUpAll(() {
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(  const GetTriviaForConcreteNumberEvent('1'));
    registerFallbackValue(MyTypeFake());
  });


  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc =  NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('test that initial state should be empty',
      () => {expect(bloc!.state, equals(Empty()))});

  group('GetTriviaForConcreteNumbers', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter!.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    void setUpMockInputConverterFailed() =>
        when(() => mockInputConverter!.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

    void setUpMockGetConcreteTriviaSuccess() =>
        when(() => mockGetConcreteNumberTrivia!(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));


    test(
        'should call the input converter to validate and convert the string to an unsigned int',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteTriviaSuccess();
      //act
      bloc!.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(
          () => mockInputConverter!.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when state is invalid', () async {
      //arrange
      setUpMockInputConverterFailed();
      //setUpMockGetConcreteTriviaSuccess();
      //assert later
      final expected = [const Error(message: invalidInputFailureMessage)];
      expectLater(bloc!.stream, emitsInOrder(expected));

      //act
      bloc!.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from the concrete use case', () async* {

       //arrange
      when(() => mockGetConcreteNumberTrivia!(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      when(()=> bloc!.getTriviaForConcreteNumberEventFunction(const GetTriviaForConcreteNumberEvent(tNumberString), MyTypeFake()))  .thenAnswer((_) async{});
       //act
      bloc!.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia!(any()));
      //assert
      verify(() => mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)));
    });

    test('should emit [loading, loaded] when data is gotten successfully',
        () async* {
      //arrange
          when(() => mockGetConcreteNumberTrivia!(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          //act
          bloc!.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          //assert later
          final expected = [Empty(), Loading(), const Loaded(trivia: tNumberTrivia)];
          expectLater(bloc!.stream, emitsInOrder(expected));
    });

    test('should emit [loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia!(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      // act
      bloc!.add(const GetTriviaForConcreteNumberEvent('-1'));
    });

    test('should emit [loading, Error] with proper message when getting data fails', () async {
      //arrange
      setUpMockInputConverterSuccess();

      when(() => mockGetConcreteNumberTrivia!(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });


///Random number Trivia

  group('GetTriviaForRandomNumber', () {

    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockGetRandomTriviaSuccess() =>
        when(() => mockGetRandomNumberTrivia!(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
      'should get data from the random use case',
          () async {
        // arrange

            when(() => mockGetRandomNumberTrivia!(any()))
                .thenAnswer((_) async => const Right(tNumberTrivia));

        // act
        bloc!.add(GetTriviaForRandomNumberEvent());
        await untilCalled(() => mockGetRandomNumberTrivia!(any()));

        // assert
        verify(
              () => mockGetRandomNumberTrivia!(NoParams()),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(() => mockGetRandomNumberTrivia!(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data from server fails',
          () async {
        // arrange
        when(() => mockGetRandomNumberTrivia!(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async{
        // arrange
        when(() => mockGetRandomNumberTrivia!(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumberEvent());
      },
    );
  });

}

class FakeNoParams extends Fake implements Params{
}

class FakeParams extends Fake implements NoParams {
}

class MyTypeFake extends Fake implements Emitter<NumberTriviaState> {}