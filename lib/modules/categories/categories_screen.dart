import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {

      },
      builder: (context, state)
      {
        return ListView.separated(
          itemBuilder: (context, index) => buildCatIte(ShopCubit.get(context).categoriesModel!.data!.data[index]),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget buildCatIte(GetDataModel model) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children:  [
        Image(
          width: 100.0,
          height: 100.0,
          image: NetworkImage(
            model.image!,
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
         Text(
          model.name!,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const Icon(
            Icons.arrow_forward_ios_outlined
        ),

      ],
    ),
  );
}
