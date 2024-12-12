
import 'package:bitirme_web/dependency_injection/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/home_page.dart';
import '../utils/utils.dart';
import 'home_cubit.dart';
import 'home_states.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<HomeCubit>(),
      child: buildScaffold(),
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar:AppBar(
        title: Text('TÜRKÇE VARLIK İSMİ TANIMA ARACI'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
        },
        builder: (context, state) {

          if (state is InitState) {

            return HomePage(locator.get<HomeCubit>(),"","",0);

          } else if (state is LoadingState) {
            return buildLoading();

          } else if (state is ResponseState) {
            debugPrint("RESPONE ");
            return(HomePage(locator.get<HomeCubit>(),state.data.sentences!,Utils.getOutput( state.data.sentences!,state.result.data!),state.data.chosenModel!));
          }

          else {
            final error = state as ErrorState;
            return buildError(error);
          }
          return buildLoading();
        },
      ),
    );
  }

  Center buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Center buildError(ErrorState error) {
    return Center(
      child: Text(error.message),
    );
  }
}