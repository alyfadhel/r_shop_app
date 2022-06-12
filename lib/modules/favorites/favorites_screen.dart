import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/models/FavoriteModel.dart';

import '../../layout/cubit/cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! ShopLoadingGetFavoritesState,
          widgetBuilder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildListProduct(
                ShopCubit.get(context)
                    .favoriteModel!
                    .data!
                    .data![index]
                    .product!,
                context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 15.0,
                end: 15.0,
              ),
              child: Divider(
                height: 1.0,
                color: Colors.grey[400],
              ),
            ),
            itemCount: ShopCubit.get(context).favoriteModel!.data!.data!.length,
          ),
          fallbackBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }


}

//ShopCubit.get(context).favorites [model.id] ==
