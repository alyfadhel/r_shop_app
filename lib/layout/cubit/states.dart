import 'package:r_shop_app/models/change_favorites_model.dart';
import 'package:r_shop_app/models/login_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates
{
  final String error;

  ShopErrorHomeDataState(this.error);
}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates
{
  final String error;

  ShopErrorCategoriesState(this.error);

}

class ShopSuccessChangeFavoritesState extends ShopStates
{
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates
{
  final String error;

  ShopErrorChangeFavoritesState(this.error);
}

class ChangeFavoritesState extends ShopStates{}


class ShopLoadingGetFavoritesState extends ShopStates
{}

class ShopSuccessGetFavoritesState extends ShopStates
{}

class ShopErrorGetFavoritesState extends ShopStates
{
  final String error;

  ShopErrorGetFavoritesState(this.error);
}

class ShopLoadingLoginState extends ShopStates{}

class ShopSuccessLoginState extends ShopStates
{
  final LoginModel userModel;

  ShopSuccessLoginState(this.userModel);
}

class ShopErrorLoginState extends ShopStates
{
  final String error;

  ShopErrorLoginState(this.error);
}

class ChangePassVisibility extends ShopStates{}


class ShopLoadingUpdateProfile extends ShopStates{}

class ShopSuccessUpdateProfile extends ShopStates
{
  final LoginModel loginModel;

  ShopSuccessUpdateProfile(this.loginModel);
}

class ShopErrorUpdateProfile extends ShopStates
{
  final String error;

  ShopErrorUpdateProfile(this.error);

}

