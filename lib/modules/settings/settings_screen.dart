import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/layout/shop_layout.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';
import 'package:r_shop_app/styles/themes/bloc/cubit.dart';

var nameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var formKey = GlobalKey<FormState>();

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateProfile) {
          if (state.loginModel.status!) {
            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.data!.token,
            ).then((value) {
              token = state.loginModel.data!.token;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShopLayoutScreen(),
                ),
              );
            });
          }
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context);
        nameController.text = model.userModel!.data!.name!;
        emailController.text = model.userModel!.data!.email!;
        phoneController.text = model.userModel!.data!.phone!;
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              ShopCubit.get(context).userModel != null,
          widgetBuilder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateProfile)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Theme',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              AppThemeModeCubit.get(context)
                                  .changeAppThemeMode();
                            },
                            icon: const Icon(
                              Icons.brightness_4_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.person,
                            label: 'name',
                            radius: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.email_outlined,
                            label: 'email address',
                            radius: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.phone_android_outlined,
                            label: 'phone',
                            radius: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          buildTextButton(
                            onPressedTextButton: () {
                              signOut(context);
                            },
                            text: 'logout',
                            radius: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          buildTextButton(
                            onPressedTextButton: () {
                              if (formKey.currentState!.validate()) {
                                ShopCubit.get(context).updateProfile(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'update',
                            radius: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          fallbackBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
