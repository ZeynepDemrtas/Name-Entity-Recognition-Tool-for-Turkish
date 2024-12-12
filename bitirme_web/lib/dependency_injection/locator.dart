import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../api/result_api.dart';
import '../cubit/home_cubit.dart';
import '../repository/repository.dart';

final locator=GetIt.instance;

class DependencyInjection{

  DependencyInjection(){
    provideApi();
    provideRepositories();
    provideViewModels();

  }
  void provideApi(){
    locator.registerLazySingleton<RestClient>(() => RestClient(Dio(BaseOptions(contentType: 'application/json'
    )))
    );
  }

  void provideRepositories(){
    locator.registerLazySingleton<Repository>(() => Repository());
  }

  void provideViewModels(){
    locator.registerLazySingleton<HomeCubit>(() => HomeCubit());


  }



}