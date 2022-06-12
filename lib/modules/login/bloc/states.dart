import 'package:r_shop_app/models/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates{}

class ChangePasswordVisibility extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}
class ShopLoginSuccessState extends ShopLoginStates
{
  final LoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}
class ShopLoginErrorState extends ShopLoginStates
{
  final String error;

  ShopLoginErrorState(this.error);
}