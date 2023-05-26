
import 'package:dartz/dartz.dart';
import 'package:trivianumbers/core/error/failure.dart';

class InputConverter{
    Either<Failure, int> stringToUnsignedInteger(String str){
        try{
             int intValue = int.parse(str);
            if(intValue <0){
                throw const FormatException();
            }else{
                return Right(intValue);
            }
        } on FormatException{
           return Left(InvalidInputFailure());
        }
    }
}

class InvalidInputFailure extends Failure{}