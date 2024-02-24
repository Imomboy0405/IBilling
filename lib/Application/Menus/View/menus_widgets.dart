import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/Profile/Bloc/profile_bloc.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const MyAppBar({
    super.key,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.darker,
      surfaceTintColor: AppColors.darker,
      titleSpacing: 20,
      title: Row(
        children: [
          // #color_image
          const Image(
            image: AssetImage('assets/icons/ic_color.png'),
            width: 24,
            height: 24,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 12),

          // #new_text
          Text(titleText, style: AppTextStyles.style18),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 57);
}

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.screenWidth,
    required this.bloc,
  });

  final double screenWidth;
  final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      height: 83,
      decoration: const BoxDecoration(
        color: AppColors.darker,
      ),
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
        itemBuilder: (context, index) => SizedBox(
          width: screenWidth * .193,
          child: MaterialButton(
            onPressed: () => bloc.add(MainMenuButtonEvent(index: index)),
            splashColor: AppColors.transparentWhite,
            highlightColor: AppColors.transparentBlack,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // #menu_icon
                Image(
                  image: index + 1 == bloc.currentScreen
                      ? bloc.listOfMenuIcons[index + 5]
                      : bloc.listOfMenuIcons[index],
                  height: index + 1 == bloc.currentScreen ? 28 : 24,
                  width: index + 1 == bloc.currentScreen ? 28 : 24,
                ),

                // #menu_text
                Text(
                    bloc.listOfMenuTexts[index].tr(),
                    style: index + 1 == bloc.currentScreen
                        ? AppTextStyles.style21
                        :AppTextStyles.style22
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
    required this.bloc,
    required this.textTitle,
    required this.textCancel,
    this.textDone,
    required this.functionCancel,
    this.functionDone,
    required this.child,
    this.doneButton = false,
  });

  final ProfileBloc bloc;
  final String textTitle;
  final String textCancel;
  final String? textDone;
  final Function functionCancel;
  final Function? functionDone;
  final Widget child;
  final bool doneButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        // #backgoround
        InkWell(
          onTap: () => functionCancel(),
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: AppColors.transparentBlack,
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(textTitle, style: AppTextStyles.style20),
              const SizedBox(height: 16),
              child,
              // #cancel_done_button
              Row(
                mainAxisAlignment: doneButton
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  SelectButton(
                      context: context,
                      text: textCancel,
                      function: () => functionCancel(),
                      select: false,
                  ),

                  if(doneButton)
                    SelectButton(
                    context: context,
                    text: textDone!,
                    function: () => functionDone!(),
                    select: true,
                    selectFunctionOn: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyProfileButton extends StatelessWidget {
  final Function function;
  final String text;
  final Widget endElement;

  const MyProfileButton({
    super.key,
    required this.text,
    required this.function,
    required this.endElement,
  });



  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => function(),
      height: 44,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppTextStyles.style19),
          endElement,
        ],
      ),
    );
  }
}

MaterialButton myNewInitialButton({required String ic, required String text, required Function function}) {
  return MaterialButton(
    onPressed: () => function(),
    height: 46,
    color: AppColors.gray,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: Row(
      children: [
        Image(
          image: AssetImage('assets/icons/$ic.png'),
          height: 26,
          width: 26,
        ),
        const SizedBox(width: 10),
        Text(text, style: AppTextStyles.style24)
      ],
    ),
  );
}

class MyNewTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onChanged;
  final Function onSubmitted;
  final bool suffixIconDone;
  final String snackBarText;
  final TextInputType textInputType;
  final bool isMoney;

  const MyNewTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.suffixIconDone,
    required this.snackBarText,
    required this.textInputType,
    this.isMoney = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: controller.text.isNotEmpty || focusNode.hasFocus ? AppTextStyles.style26 : AppTextStyles.style25,
        ),
        const SizedBox(height: 4),

        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (v) => onChanged(),
            onTap: () => onChanged(),
            onSubmitted: (v) => onSubmitted(),
            style: AppTextStyles.style7,
            cursorColor: AppColors.blue,
            keyboardType: textInputType,
            textInputAction: TextInputAction.next,
            inputFormatters: textInputType == TextInputType.number
                ? [
                  isMoney
                      ? CurrencyInputFormatter(
                          trailingSymbol: 'sum'.tr(),
                          useSymbolPadding: true,
                          mantissaLength: 0,
                          thousandSeparator:
                          ThousandSeparator.Space,
                  ) : MaskedInputFormatter('000 000 000'),
                  ]
                : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15, right: 10),
              suffixIcon: controller.text.isNotEmpty || focusNode.hasFocus
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => !suffixIconDone
                        ? mySnackBar(context: context, txt: snackBarText)
                        : {},
                      icon: suffixIconDone
                        ? const Icon(Icons.done, color: AppColors.blue)
                        : const Icon(Icons.error_outline,color: AppColors.red),
                  )
                  : const SizedBox.shrink(),
              enabledBorder: myInputBorder(
                itsColor1: controller.text.isNotEmpty || focusNode.hasFocus,
                color1: AppColors.blue,
                color2: AppColors.gray,
              ),
              focusedBorder: myInputBorder(color1: AppColors.blue),
              errorBorder: myInputBorder(color1: AppColors.red),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyDropdownButton extends StatelessWidget {
  const MyDropdownButton({
    super.key,
    required this.status,
    required this.titleText,
    required this.focusNode,
    required this.statusList,
    required this.onChanged,
  });

  final String? status;
  final String titleText;
  final List<String> statusList;
  final FocusNode focusNode;
  final void Function(String status) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText, style: status == null ? AppTextStyles.style25 : AppTextStyles.style26),
        const SizedBox(height: 4),

        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 44,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              width: 1.2,
              color: status == null
                  ? AppColors.gray
                  : AppColors.blue,
            ),
          ),
          child: DropdownButton<String>(
            value: status,
            isExpanded: true,
            icon: const Icon(Icons.expand_circle_down_rounded),
            focusNode: focusNode,
            underline: const SizedBox.shrink(),
            padding: const EdgeInsets.only(left: 15, right: 10),
            borderRadius: BorderRadius.circular(6),
            dropdownColor: AppColors.dark,
            iconEnabledColor: status == null ? AppColors.gray : AppColors.blue,
            selectedItemBuilder: (value) {
              return status != null
                  ? statusList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTextStyles.style7),
                );
              }).toList()
                  : [const DropdownMenuItem(child: SizedBox.shrink())];
            },
            items: statusList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: AppTextStyles.style23),
              );
            }).toList(),
            onChanged: (status) => onChanged(status!),
          ),
        ),
      ],
    );
  }
}
