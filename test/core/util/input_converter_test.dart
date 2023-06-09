import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivianumbers/core/util/input_converter.dart';

void main(){
  InputConverter? inputConverter;
  
  setUpAll(() {
    inputConverter = InputConverter();
  });
  
  group('StringToUnsignedInt', () { 
    test('should return an integer when the string represent an unsigned integer', () async{
      //arrange
const str ='123';
      //act
final result = inputConverter!.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', () async{
      //arrange
const str ='123/';
      //act
final result = inputConverter!.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative integer', () async{
      //arrange
const str ='-1';
      //act
final result = inputConverter!.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}