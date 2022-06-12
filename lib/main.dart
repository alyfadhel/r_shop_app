import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/shop_layout.dart';
import 'package:r_shop_app/modules/login/login_screen.dart';
import 'package:r_shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';
import 'package:r_shop_app/network/remote/dio_helper.dart';
import 'package:r_shop_app/styles/themes/bloc/cubit.dart';
import 'package:r_shop_app/styles/themes/bloc/observer.dart';
import 'package:r_shop_app/styles/themes/bloc/states.dart';
import 'package:r_shop_app/styles/themes/themes.dart';

//Z3o43OeTUhxhkgM4dh2GMcAUdGVXhWaWCNraMyO2wUqjLuv3YuaJIU15wkJotyMETs1ONL
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);
  Widget widget;
  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayoutScreen();
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  //print(onBoarding);
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  const MyApp({this.isDark, this.startWidget, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
        BlocProvider(
          create: (context) => AppThemeModeCubit()
            ..changeAppThemeMode(
              fromShared: isDark,
            ),
        ),
      ],
      child: BlocConsumer<AppThemeModeCubit, AppThemeModeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: AppThemeModeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
