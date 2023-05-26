part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}


class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent{
  final String numberString;

  const GetTriviaForConcreteNumberEvent(this.numberString);

  @override
  List<String> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent{

  @override
  List<Object?> get props => [];
}
