import 'package:dartz/dartz.dart';
import 'package:trivianumbers/core/error/exceptions.dart';
import 'package:trivianumbers/core/error/failure.dart';
import 'package:trivianumbers/core/network/network_info.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:trivianumbers/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../model/number_trivia_model.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number,) async{
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser getConcreteOrRandom) async{
    if(await networkInfo.isConnected){
      try{
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel)  ;
        return Right(remoteTrivia );

      } on ServerException{
        return Left(ServerFailure());
      }
    }
    else{
      try{
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException{
        return Left(CacheFailure());
      }
    }
  }
}
