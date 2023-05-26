import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/core/usecase/usecase.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidInputFailureMessage =
    "Invalid input- Please input only positive integer";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia? getConcreteNumberTrivia;
  final GetRandomNumberTrivia? getRandomNumberTrivia;
  final InputConverter? inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()){
    on<GetTriviaForConcreteNumberEvent>(getTriviaForConcreteNumberEventFunction);
    on<GetTriviaForRandomNumberEvent>(getTriviaForRandomNumberEventFunction);
  }

  FutureOr<void> getTriviaForConcreteNumberEventFunction(
      GetTriviaForConcreteNumberEvent event, Emitter<NumberTriviaState> emit) async{
    final inputEither =
        inputConverter!.stringToUnsignedInteger(event.numberString);

    await inputEither.fold((failure) async {
      emit(
        const Error(message: invalidInputFailureMessage),
      );
    }, (integer) async {
      emit(Empty());
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia!(Params(number: integer));
        await failureOrTrivia.fold(
        (failure) async {
          emit(Error(message: _mapFailureToMessage(failure)));
        },
         (trivia) async{
          emit(Loaded(trivia: trivia));
        },
      );
    });
  }

  FutureOr<void> getTriviaForRandomNumberEventFunction(
      GetTriviaForRandomNumberEvent event,
      Emitter<NumberTriviaState> emit) async {

    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia!(NoParams());
    failureOrTrivia.fold(
      (failure) async {
        emit(Error(message: _mapFailureToMessage(failure)));
      },
      (trivia) async {
        emit(Loaded(trivia: trivia));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
