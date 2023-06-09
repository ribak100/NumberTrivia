import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure({this.properties = const <dynamic>[]});

  @override
  List<dynamic> get props => properties;
}

//general failure

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
