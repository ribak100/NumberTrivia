import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trivianumbers/core/error/exceptions.dart';

import 'package:trivianumbers/features/number_trivia/data/model/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  Future<NumberTriviaModel> _getConreteOrRandomTrivia(String endpoint) async{
    final response =  await client.get(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else{
      throw ServerException();
    }

  }

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number){
    return _getConreteOrRandomTrivia('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia(){
  return _getConreteOrRandomTrivia('http://numbersapi.com/random');
  }

}
