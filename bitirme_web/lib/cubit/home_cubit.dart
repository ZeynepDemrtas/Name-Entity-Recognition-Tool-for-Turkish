import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dependency_injection/locator.dart';
import '../model/data.dart';
import '../repository/repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  final _repository= locator.get<Repository>();
  HomeCubit():super(InitState());

  //Doing API call using repository
  Future<void>fetchModelResult(Data data) async{
    emit(LoadingState());
    try{

      final response= await _repository.fetchResult(data);
      print("CUBIT");
      emit(ResponseState(response!,data));
    }
    catch(e){
      debugPrint('ERROR : ${e.toString()}');
      emit(ErrorState(e.toString()));
    }

  }
}


