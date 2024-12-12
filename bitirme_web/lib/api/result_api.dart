import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../model/data.dart';
import '../model/result.dart';

part 'result_api.g.dart';

@RestApi(baseUrl: 'http://127.0.0.1:8000')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @POST("/NER")
  Future<Result> getResult(@Query('sentences') String sentences,@Query('chosenModel') int chosenModel);

}