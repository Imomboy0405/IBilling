import 'package:i_billing/Application/Welcome/SignIn/Bloc/sign_in_bloc.dart'
    as sign_in;
import 'package:i_billing/Application/Welcome/Start/Bloc/start_bloc.dart'
    as start;
import 'package:i_billing/Application/Welcome/SignUp/Bloc/sign_up_bloc.dart'
    as sign_up;
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../Configuration/app_colors.dart';
import '../../../Configuration/app_text_styles.dart';

class MyFlagButton extends StatelessWidget {
  const MyFlagButton({
    super.key,
    required this.currentLang,
    required this.pageContext,
    required this.pageName,
  });

  final String pageName;
  final BuildContext pageContext;
  final Language currentLang;
  static const List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            elevation: 0,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.47,
                maxChildSize: 0.5,
                expand: true,
                builder:
                    (BuildContext cont, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: AppColors.darker,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 4,
                      itemBuilder: (c, index) {
                        return index == 0
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'choose_lang'.tr(),
                                  style: AppTextStyles.style4,
                                ),
                              )
                            : RadioListTile(
                                activeColor: AppColors.blue,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                secondary: Image(
                                  image: AssetImage(
                                      'assets/icons/ic_flag_${lang[index - 1].name}.png'),
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.fill,
                                ),
                                title: Text('button_$index'.tr(),
                                    style: AppTextStyles.style15),
                                selected: lang[index - 1] == currentLang,
                                value: lang[index - 1],
                                groupValue: currentLang,
                                onChanged: (value) {
                                  switch (pageName) {
                                    case '/start_page':
                                      pageContext.read<start.StartBloc>().add(
                                          start.SelectLanguageEvent(
                                              lang: value as Language));
                                      break;
                                    case '/sign_in_page':
                                      pageContext
                                          .read<sign_in.SignInBloc>()
                                          .add(sign_in.SelectLanguageEvent(
                                              lang: value as Language));
                                      break;
                                    case '/sign_up_page':
                                      pageContext
                                          .read<sign_up.SignUpBloc>()
                                          .add(sign_up.SelectLanguageEvent(
                                              lang: value as Language));
                                  }
                                  Navigator.pop(cont);
                                });
                      },
                    ),
                  );
                },
              );
            },
          );
        },
        icon: Image(
          image: AssetImage('assets/icons/ic_flag_${currentLang.name}.png'),
          width: 28,
          height: 28,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.pageName,
    required this.context1,
    required this.controller,
    required this.keyboard,
    required this.focus,
    required this.errorTxt,
    required this.errorState,
    required this.suffixIc,
    required this.enterStateAndField,
    required this.icon,
    required this.labelTxt,
    required this.hintTxt,
    required this.snackBarTxt,
    this.obscure,
  });

  final String pageName;
  final BuildContext context1;
  final TextEditingController controller;
  final TextInputType keyboard;
  final FocusNode focus;
  final String errorTxt;
  final bool errorState;
  final bool suffixIc;
  final bool enterStateAndField;
  final IconData icon;
  final String labelTxt;
  final String hintTxt;
  final String snackBarTxt;
  final bool? obscure;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: MediaQuery.of(context1).size.width - 60,
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: TextField(
          obscureText: icon == Icons.lock ? obscure! : false,
          cursorColor: AppColors.blue,
          controller: controller,
          style: AppTextStyles.style7,
          onChanged: (v) {
            if (icon == Icons.phone && v.isNotEmpty) {
              if (v.substring(0, 1) != '(') {
                String newInput = '(${v[0]}';
                controller.text = newInput;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: newInput.length),
                );
              }
            }
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.SignInChangeEvent());
                break;
            }
          },
          onTap: () {
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.SignInChangeEvent());
                break;
            }
          },
          onSubmitted: (v) {
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.OnSubmittedEvent(password: icon == Icons.lock));
                break;
            }
          },
          textInputAction: icon == Icons.lock ? TextInputAction.done : TextInputAction.next,
          keyboardType: keyboard,
          inputFormatters: icon == Icons.add
              ? [MaskTextInputFormatter(mask: '(##) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.eager)]
              : null,
          focusNode: focus,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            errorText: errorState ? errorTxt : null,
            prefixIcon: Icon(icon,
                color: enterStateAndField || focus.hasFocus
                    ? AppColors.blue
                    : AppColors.darkGrey),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // #eye_button
                  icon == Icons.lock && controller.text.isNotEmpty
                    ? IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    switch (pageName) {
                      case '/sign_in_page':
                        context1
                            .read<sign_in.SignInBloc>()
                            .add(sign_in.EyeEvent());
                        break;
                    }
                  },
                  icon: Icon(
                    obscure!
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: AppColors.blue,
                  ),
                )
                    : const SizedBox.shrink(),

                // #error_button_and_done
                controller.text.isNotEmpty || focus.hasFocus
                    ? IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => !suffixIc
                        ? mySnackBar(context: context1, txt: snackBarTxt)
                        : {},
                    icon: suffixIc
                        ? const Icon(Icons.done, color: AppColors.blue)
                        : const Icon(Icons.error_outline, color: AppColors.red)
                )
                    : const SizedBox.shrink(),
              ],
            ),

            labelText: labelTxt,
            prefixText: icon == Icons.phone ? '+998 ' : null,
            hintText: hintTxt,
            hintStyle: AppTextStyles.style6,
            prefixStyle: AppTextStyles.style7,
            labelStyle: controller.text.isNotEmpty || focus.hasFocus
                ? AppTextStyles.style3
                : AppTextStyles.style6,
            border: myInputBorder(color1: AppColors.blue),
            enabledBorder: myInputBorder(
              color1: AppColors.blue,
              color2: AppColors.disableBlue,
              itsColor1: enterStateAndField,
            ),
            errorBorder: myInputBorder(color1: AppColors.red),
            focusedBorder: myInputBorder(color1: AppColors.blue),
          ),
        ),
      ),
    );

  }
}

class SelectButton extends StatelessWidget {
  const SelectButton({
    super.key,
    required this.context,
    required this.function,
    required this.text,
    required this.select,
  });

  final BuildContext context;
  final Function function;
  final String text;
  final bool select;

  @override
  Widget build(BuildContext context) {
    return select
        ? Container(
            height: 44,
            width: (MediaQuery.of(context).size.width - 105) / 2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              text,
              style: AppTextStyles.style13,
            ),
          )
        : MaterialButton(
            onPressed: () => function(),
            color: AppColors.disableBlue,
            splashColor: AppColors.blue,
            highlightColor: AppColors.disableBlue,
            minWidth: (MediaQuery.of(context).size.width - 105) / 2,
            height: 44,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: Text(
              text,
              style: AppTextStyles.style14,
            ),
          );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar({required String txt, required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 40,
        margin: const EdgeInsets.only(bottom: 80),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.red, borderRadius: BorderRadius.circular(6)),
        child: Text(txt, style: AppTextStyles.style13),
      ),
    ),
  );
}

TextButton myTextButton(
    {required BuildContext context,
    required String assetIc,
    required Function() onPressed,
    required String txt}) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Change the border radius as needed
        ),
      ),
      overlayColor: MaterialStateProperty.all(AppColors.disableBlue),
    ),
    child: Row(
      children: [
        SizedBox(
            height: 25,
            child: Image(image: AssetImage('assets/icons/ic_$assetIc.png'))),
        Text(' $txt', style: AppTextStyles.style9),
      ],
    ),
  );
}

OutlineInputBorder myInputBorder({required Color color1, bool itsColor1 = true, Color? color2}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(width: 1.2, color: itsColor1 ? color1 : color2!),
  );
}

class MyPhoneTextField extends StatelessWidget {
  const MyPhoneTextField({
    super.key,
    required this.bloc,
    required this.state,
    required this.pageName,
    required this.context1,
    required this.controller,
    required this.keyboard,
    required this.focus,
    required this.errorTxt,
    required this.errorState,
    required this.suffixIc,
    required this.enterStateAndField,
    required this.icon,
    required this.labelTxt,
    required this.hintTxt,
    required this.snackBarTxt,
    this.obscure,
  });

  final sign_in.SignInBloc bloc;
  final dynamic state;
  final String pageName;
  final BuildContext context1;
  final TextEditingController controller;
  final TextInputType keyboard;
  final FocusNode focus;
  final String errorTxt;
  final bool errorState;
  final bool suffixIc;
  final bool enterStateAndField;
  final IconData icon;
  final String labelTxt;
  final String hintTxt;
  final String snackBarTxt;
  final bool? obscure;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: MediaQuery.of(context1).size.width - 60,
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: TextField(
          obscureText: icon == Icons.lock ? obscure! : false,
          cursorColor: AppColors.blue,
          controller: controller,
          style: AppTextStyles.style7,
          onChanged: (v) {
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.SignInChangeEvent());
                break;
            }
          },
          onTap: () {
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.SignInChangeEvent());
                break;
            }
          },
          onSubmitted: (v) {
            switch (pageName) {
              case '/sign_in_page':
                context1
                    .read<sign_in.SignInBloc>()
                    .add(sign_in.OnSubmittedEvent(password: icon == Icons.lock));
                break;
            }
          },
          textInputAction: icon == Icons.lock ? TextInputAction.done : TextInputAction.next,
          keyboardType: keyboard,
          inputFormatters: icon == Icons.phone
              ? [MaskTextInputFormatter(mask: '(##) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.eager)]
              : null,
          focusNode: focus,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            errorText: errorState ? errorTxt : null,
            prefixIcon: Icon(icon,
                color: enterStateAndField || focus.hasFocus
                    ? AppColors.blue
                    : AppColors.darkGrey),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // #eye_button
                icon == Icons.lock && controller.text.isNotEmpty
                    ? IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    switch (pageName) {
                      case '/sign_in_page':
                        context1
                            .read<sign_in.SignInBloc>()
                            .add(sign_in.EyeEvent());
                        break;
                    }
                  },
                  icon: Icon(
                    obscure!
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: AppColors.blue,
                  ),
                )
                    : const SizedBox.shrink(),

                // #error_button_and_done
                controller.text.isNotEmpty || focus.hasFocus
                    ? IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => !suffixIc
                        ? mySnackBar(context: context1, txt: snackBarTxt)
                        : {},
                    icon: suffixIc
                        ? const Icon(Icons.done, color: AppColors.blue)
                        : const Icon(Icons.error_outline, color: AppColors.red)
                )
                    : const SizedBox.shrink(),
              ],
            ),

            labelText: labelTxt,
            prefixText: icon == Icons.phone ? '+998 ' : null,
            hintText: hintTxt,
            hintStyle: AppTextStyles.style6,
            prefixStyle: AppTextStyles.style7,
            labelStyle: controller.text.isNotEmpty || focus.hasFocus
                ? AppTextStyles.style3
                : AppTextStyles.style6,
            border: myInputBorder(color1: AppColors.blue),
            enabledBorder: myInputBorder(
              color1: AppColors.blue,
              color2: AppColors.disableBlue,
              itsColor1: enterStateAndField,
            ),
            errorBorder: myInputBorder(color1: AppColors.red),
            focusedBorder: myInputBorder(color1: AppColors.blue),
          ),
        ),
      ),
    );
  }
}
