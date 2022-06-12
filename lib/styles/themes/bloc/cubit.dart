import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';
import 'package:r_shop_app/styles/themes/bloc/states.dart';

class AppThemeModeCubit extends Cubit<AppThemeModeStates>
{
  AppThemeModeCubit() : super(AppThemeInitialModeState());

  static AppThemeModeCubit get(context) => BlocProvider.of(context);

   bool isDark = true;

  void changeAppThemeMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppThemeChangeModeState());
    }else{
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value)
      {
        emit(AppThemeChangeModeState());
      });
    }
  }

}