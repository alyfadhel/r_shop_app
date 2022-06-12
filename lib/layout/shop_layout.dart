import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/modules/login/login_screen.dart';
import 'package:r_shop_app/modules/search/search_screen.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';

class ShopLayoutScreen extends StatelessWidget {
  const ShopLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {

      },
      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Salla',
            ),
            actions:
            [
              IconButton(
                onPressed: ()
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen(),
                      ),
                  );
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNav(index);
            },
            items: cubit.bottomItems,
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
