import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:r_shop_app/layout/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String>? validator,
  required IconData prefix,
  required String label,
  Function()? onPressedSuffix,
  IconData? suffix,
  bool isPassword = false,
  bool isUpperCase = true,
  ValueChanged<String>? onFieldSubmitted,
  ValueChanged<String>? onChanged,
  GestureTapCallback? onTap,
  double radius = 0.0,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  validator: validator,
  obscureText: isPassword,
  onFieldSubmitted: onFieldSubmitted,
  onChanged: onChanged,
  onTap: onTap,
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null?
    IconButton(
        onPressed: onPressedSuffix,
        icon: Icon(suffix),
    ) : null,
    label: Text(
      isUpperCase ? label.toUpperCase() : label,
    ),
  ),
);


Widget buildTextButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 0.0,
  required Function() onPressedTextButton,
  required String text,
  bool isUpperCase = true,
})=> Container(
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radius),

  ),
  child: TextButton(
    onPressed: onPressedTextButton,
    child: Text(
        isUpperCase ? text.toUpperCase() : text,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
);

Widget buildDefaultTextButton({
  required Function() onPressedTextButton,
  required String text,
  bool isUpperCase = true,
})=>TextButton(
    onPressed: onPressedTextButton,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue
      ),
    ),
);

void showToast ({
  required String text,
  required ToastState state,
}) => Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum ToastState{success,error,warning}

Color chooseToastColor(ToastState state)
{
  Color color;
  switch(state)
  {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
    case ToastState.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct(model, context,{bool isOldPrice = true}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: SizedBox(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              width: 120.0,
              height: 120.0,
              image: NetworkImage(
                model.image!,
              ),
            ),
            if (model.discount != 0 && isOldPrice)
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
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.3,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    model.price.round().toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (model.discount != 0 && isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.id!);
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor:
                      ShopCubit.get(context).favorites[model.id!] ==
                          true
                          ? Colors.blue
                          : Colors.grey,
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
    ),
  ),
);
