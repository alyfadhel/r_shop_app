import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:r_shop_app/compontents/compontents.dart';
import 'package:r_shop_app/compontents/constants.dart';
import 'package:r_shop_app/layout/shop_layout.dart';
import 'package:r_shop_app/modules/login/bloc/cubit.dart';
import 'package:r_shop_app/modules/login/bloc/states.dart';
import 'package:r_shop_app/modules/register/register.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state)
        {
          if(state is ShopLoginSuccessState)
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
          return Scaffold(
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
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Login to browse hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'email address must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.email_outlined,
                          label: 'email address',
                          radius: 10.0,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'password must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.lock_outline,
                            label: 'password',
                            radius: 10.0,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            onPressedSuffix: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => state is! ShopLoginLoadingState,
                          widgetBuilder: (context) => buildTextButton(
                            onPressedTextButton: () {
                              if (formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).loginUser(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'login',
                            radius: 10.0,
                          ),
                          fallbackBuilder: (context) => const Center(child: CircularProgressIndicator())
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have Account ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            buildDefaultTextButton(
                              onPressedTextButton: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              text: 'sign out',
                            ),
                          ],
                        ),
                      ],
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
