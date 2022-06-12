import 'package:flutter/material.dart';
import 'package:r_shop_app/modules/login/login_screen.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';

void signOut(context)
{
  CacheHelper.signOut(key: 'token').then((value)
  {
    if(value)
    {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),),
              (route) => false);
    }
  });
}

 String? token = '';