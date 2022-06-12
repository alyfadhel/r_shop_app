import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/models/SearchModel.dart';
import 'package:r_shop_app/modules/search/cubit/states.dart';
import 'package:r_shop_app/network/remote/dio_helper.dart';
import 'package:r_shop_app/network/remote/end_point.dart';

class SearchCubit extends Cubit<SearchStates>
{
  SearchCubit() : super (SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text)
  {
    SearchLoadingState();
    DioHelper.postData(
        url: SEARCH,
        data:
        {
          'text' : text,
        },
      token: token,
    ).then((value)
    {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error)
    {
      emit(SearchErrorState(error.toString()));
    });
  }

}