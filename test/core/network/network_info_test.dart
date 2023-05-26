import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:trivianumbers/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements InternetConnectionChecker{}

void main() {
  NetworkInfoImpl? networkInfoImpl;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {
    test(
        'should forward the call to data connectionChecker.hasConnection', () async {
      //arrange

      when(() => mockDataConnectionChecker!.hasConnection).thenAnswer((
          _) async => true);

      //act
      final result = await networkInfoImpl!.isConnected;

      //assert

      verify(() => mockDataConnectionChecker!.hasConnection);
      expect(result, true);
    });



  });
}