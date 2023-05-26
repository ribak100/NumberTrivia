import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivianumbers/core/network/network_info.dart';
import 'package:trivianumbers/core/util/input_converter.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:trivianumbers/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:trivianumbers/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivianumbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivianumbers/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';


final sLocator = GetIt.instance;

Future<void> init() async{
  ///! Features - Number Trivia
  //Bloc
  sLocator.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sLocator(),
      getRandomNumberTrivia: sLocator(),
      inputConverter: sLocator()));

  //Use cases
  sLocator.registerLazySingleton(() => GetConcreteNumberTrivia(sLocator()));
  sLocator.registerLazySingleton(() => GetRandomNumberTrivia(sLocator()));

  //Repository
  sLocator.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sLocator(),
          localDataSource: sLocator(),
          networkInfo: sLocator()));

  // Data Sources
  sLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sLocator()));

  sLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sLocator()));

  ///! Core
  sLocator.registerLazySingleton(() => InputConverter());
  sLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sLocator()));

  ///! External
  final sharedPreferences =  await SharedPreferences.getInstance();
  sLocator.registerLazySingleton(() =>sharedPreferences);
  sLocator.registerLazySingleton(() =>http.Client());
  sLocator.registerLazySingleton(() =>InternetConnectionChecker());
}
