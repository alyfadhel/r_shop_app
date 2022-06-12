
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/models/FavoriteModel.dart';
import 'package:r_shop_app/models/categories_model.dart';
import 'package:r_shop_app/models/change_favorites_model.dart';
import 'package:r_shop_app/models/home_model.dart';
import 'package:r_shop_app/models/login_model.dart';
import 'package:r_shop_app/modules/categories/categories_screen.dart';
import 'package:r_shop_app/modules/favorites/favorites_screen.dart';
import 'package:r_shop_app/modules/products/products.dart';
import 'package:r_shop_app/modules/settings/settings_screen.dart';
import 'package:r_shop_app/network/remote/dio_helper.dart';
import 'package:r_shop_app/network/remote/end_point.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.apps,
        ),
        label: 'Categories'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
        ),
        label: 'Favorites'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: 'Settings'),
  ];
  List<Widget> screens = [
    const ProductScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      // print(homeModel!.data!.banners[0].image);
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      emit(ShopErrorHomeDataState(error.toString()));
      print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState(error.toString()));
    });
  }


  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data:
      {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState(error.toString()));
    });
  }

  FavoriteModel? favoriteModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      print(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState(error.toString()));
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingLoginState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      print(userModel!.data!.email);
      print(userModel!.data!.phone);
      emit(ShopSuccessLoginState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorLoginState(error.toString()));
    });
  }

  LoginModel? loginModel;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
}) {
    emit(ShopLoadingUpdateProfile());
    DioHelper.putData(
        url: UPDATE_PROFILE,
        data:
        {
          'name' : name,
          'email' : email,
          'phone' : phone,
        },
      token: token,
    ).then((value)
    {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.data!.name);
      print(loginModel!.data!.email);
      print(loginModel!.data!.phone);
      getUserData();
      emit(ShopSuccessUpdateProfile(loginModel!));
    }).catchError((error)
    {
      emit(ShopErrorUpdateProfile(error.toString()));
      print(error.toString());
    });
  }
}


