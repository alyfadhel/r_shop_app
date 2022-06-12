import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/models/categories_model.dart';
import 'package:r_shop_app/models/home_model.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if(!state.model.status!)
          {
            showToast(
                text: state.model.message!,
                state: ToastState.error,
            );
          }
        }
      },
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
          widgetBuilder: (context) =>
              builderWidget(ShopCubit.get(context).homeModel!, ShopCubit.get(context).categoriesModel!,context),
          fallbackBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builderWidget(HomeModel model,CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model.data!.banners
                    .map(
                      (e) => Image(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          e.image!,
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 230,
                  // aspectRatio: 16/9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                )),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoryItem(categoriesModel.data!.data[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10.0,
                        ),
                        itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.7,
              children: List.generate(
                model.data!.products.length,
                (index) => buildProduct(model.data!.products[index],context),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(GetDataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children:  [
       Image(
        image: NetworkImage(
          model.image!,
        ),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.6),
        ),
        child:  Text(
          model.name!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

  Widget buildProduct(ProductModel model, context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                width: double.infinity,
                height: 200.0,
                image: NetworkImage(
                  model.image!,
                ),
              ),
              if (model.discount != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    height: 1.3,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice.round()}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: ()
                      {
                        ShopCubit.get(context).changeFavorites(model.id!);
                      },
                      icon:  CircleAvatar(
                        radius: 15.0,
                        backgroundColor: ShopCubit.get(context).favorites[model.id] == true ? Colors.blue :  Colors.grey,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
