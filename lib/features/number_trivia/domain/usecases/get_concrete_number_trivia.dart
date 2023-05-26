
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/core/usecase/usecase.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async{
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{

  final int number;

  const Params({required this.number});

  @override
  List<dynamic> get props => [number];


}