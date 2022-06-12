import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/models/login_model.dart';
import 'package:r_shop_app/modules/login/bloc/states.dart';
import 'package:r_shop_app/modules/register/bloc/states.dart';
import 'package:r_shop_app/network/remote/dio_helper.dart';
import 'package:r_shop_app/network/remote/end_point.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>
{
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePassVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ChangePassVisibility());
  }

  LoginModel? loginModel;

  void userRegister({
  required String name,
  required String phone,
  required String email,
  required String password,

})
  {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data:
        {
          'name' : name,
          'phone' : phone,
          'email' : email,
          'password' : password,
        },
      token: token,
    ).then((value)
    {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.data!.name);
      print(loginModel!.data!.phone);
      print(loginModel!.data!.email);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error)
    {
      emit(ShopRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }



}

