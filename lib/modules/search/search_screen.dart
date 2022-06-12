import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/modules/search/cubit/cubit.dart';
import 'package:r_shop_app/modules/search/cubit/states.dart';

var searchController = TextEditingController();
var formKey = GlobalKey<FormState>();
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body:  Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'search must not empty';
                          }
                            return null;
                        },
                        prefix: Icons.search,
                        label: 'search',
                        onFieldSubmitted: (String text)
                        {
                          SearchCubit.get(context).search(text);
                        },
                      radius: 10.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if(state is SearchLoadingState)
                    const LinearProgressIndicator(),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildListProduct(SearchCubit.get(context).model!.data!.data![index],context,isOldPrice: false,),
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
                        itemCount: SearchCubit.get(context).model!.data!.data!.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
