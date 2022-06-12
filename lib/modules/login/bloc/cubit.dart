import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/models/login_model.dart';
import 'package:r_shop_app/modules/login/bloc/states.dart';
import 'package:r_shop_app/network/remote/dio_helper.dart';
import 'package:r_shop_app/network/remote/end_point.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ChangePasswordVisibility());
  }

  LoginModel? loginModel;

  void loginUser({
    required String email,
    required String password,
})
  {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data:
        {
          'email' : email,
          'password' : password,
        },
    ).then((value)
    {
      //print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      // print(loginModel!.status);
      // print(loginModel!.message);
      // print(loginModel!.data!.token);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error)
    {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

}