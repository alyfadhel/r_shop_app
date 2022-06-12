import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';
import 'package:r_shop_app/layout/cubit/states.dart';
import 'package:r_shop_app/layout/shop_layout.dart';
import 'package:r_shop_app/modules/login/bloc/cubit.dart';
import 'package:r_shop_app/modules/register/bloc/cubit.dart';
import 'package:r_shop_app/modules/register/bloc/states.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';

var nameController = TextEditingController();
var phoneController = TextEditingController();
var emailController = TextEditingController();
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state)
        {
          if(state is ShopRegisterSuccessState)
          {
            if(state.loginModel.status!)
            {
              print(state.loginModel.message!);
              print(state.loginModel.data!.token);
              showToast(
                text: state.loginModel.message!,
                state: ToastState.success,
              );
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value)
              {
                token = state.loginModel.data!.token;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopLayoutScreen(),
                  ),
                );
              });
            }else{
              print(state.loginModel.message!);
              showToast(
                text: state.loginModel.message!,
                state: ToastState.error,
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Sign In to browse hot offers',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                              return null;
                            },
                            prefix: Icons.person_outline_outlined,
                            label: 'name',
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
                                return 'Please Enter Your Phone';
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
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Your email';
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
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                              return null;
                            },
                            prefix: Icons.lock_outline,
                            label: 'password',
                            radius: 10.0,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            onPressedSuffix: () {
                              ShopRegisterCubit.get(context).changePassVisibility();
                            },
                            isPassword: ShopRegisterCubit.get(context).isPassword,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (context) => state is! ShopRegisterLoadingState,
                            widgetBuilder: (context) => buildTextButton(
                              onPressedTextButton: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'Sign out',
                              radius: 10.0,
                            ),
                            fallbackBuilder: (context) => const Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
