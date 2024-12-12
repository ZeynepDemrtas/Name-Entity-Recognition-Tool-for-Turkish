import '../model/data.dart';
import '../model/result.dart';

abstract class HomeStates{}

class InitState extends HomeStates {
}
class LoadingState  extends HomeStates{
}
class ErrorState extends HomeStates{
  final String message;
  ErrorState(this.message);
}
//This state responsible for holding the response
class ResponseState extends HomeStates{
  Result result;
  Data data;
  ResponseState (this.result,this.data);
}



