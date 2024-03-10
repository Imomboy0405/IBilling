import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/widgets/country_flag.dart';
import 'package:i_billing/Application/Welcome/SignIn/Bloc/sign_in_bloc.dart' as sign_in;
import 'package:i_billing/Application/Welcome/Start/Bloc/start_bloc.dart' as start;
import 'package:i_billing/Application/Welcome/SignUp/Bloc/sign_up_bloc.dart' as sign_up;
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Data/Service/util_service.dart';

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
                builder: (BuildContext cont, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                        color: AppColors.darker,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 4,
                      itemBuilder: (c, index) {
                        return index == 0
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'choose_lang'.tr(),
                                  style: AppTextStyles.style4(context),
                                ),
                              )
                            : RadioListTile(
                                activeColor: AppColors.blue,
                                controlAffinity: ListTileControlAffinity.trailing,
                                secondary: Image(
                                  image: AssetImage('assets/icons/ic_flag_${lang[index - 1].name}.png'),
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.fill,
                                ),
                                title: Text('button_${index - 1}'.tr(), style: AppTextStyles.style15(context)),
                                selected: lang[index - 1] == currentLang,
                                value: lang[index - 1],
                                groupValue: currentLang,
                                onChanged: (value) {
                                  switch (pageName) {
                                    case '/start_page':
                                      pageContext
                                          .read<start.StartBloc>()
                                          .add(start.SelectLanguageEvent(lang: value as Language));
                                      break;
                                    case '/sign_in_page':
                                      pageContext
                                          .read<sign_in.SignInBloc>()
                                          .add(sign_in.SelectLanguageEvent(lang: value as Language));
                                      break;
                                    case '/sign_up_page':
                                      pageContext
                                          .read<sign_up.SignUpBloc>()
                                          .add(sign_up.SelectLanguageEvent(lang: value as Language));
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

class SelectButton extends StatelessWidget {
  final BuildContext context;
  final Function function;
  final String text;
  final bool select;
  final bool selectFunctionOn;

  const SelectButton({
    super.key,
    required this.context,
    required this.function,
    required this.text,
    required this.select,
    this.selectFunctionOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => select
          ? selectFunctionOn
              ? function()
              : () {}
          : function(),
      color: select ? AppColors.blue : AppColors.transparentBlue,
      splashColor: AppColors.blue,
      elevation: 0,
      highlightColor: AppColors.transparentBlue,
      minWidth: (MediaQuery.of(context).size.width - 130) / 2,
      height: 37,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: select ? AppTextStyles.style13(context).copyWith(color: Colors.white) : AppTextStyles.style14(context),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.pageName,
    required this.context1,
    required this.controller,
    required this.keyboard,
    required this.focus,
    required this.errorTxt,
    required this.errorState,
    required this.suffixIc,
    required this.icon,
    required this.labelTxt,
    required this.hintTxt,
    required this.snackBarTxt,
    this.obscure,
    this.countryData,
    this.phoneInputFormatter,
    this.focusCountry = false,
    this.disabled = false,
    this.actionDone = false,
  });

  final String pageName;
  final BuildContext context1;
  final TextEditingController controller;
  final TextInputType keyboard;
  final FocusNode focus;
  final String errorTxt;
  final bool errorState;
  final bool suffixIc;
  final IconData icon;
  final String labelTxt;
  final String hintTxt;
  final String snackBarTxt;
  final bool? obscure;
  final bool disabled;
  final bool actionDone;
  final PhoneInputFormatter? phoneInputFormatter;
  final List<String> countryIsoCodes = [
    'UZ',
    'RU',
    'US',
    'AF',
    'KZ',
    'KG',
    'TJ',
    'TM',
  ];
  final bool focusCountry;
  final PhoneCountryData? countryData;

  @override
  Widget build(BuildContext context) {
    if (icon == Icons.phone) {
      PhoneInputFormatter.replacePhoneMask(countryCode: 'UZ', newMask: '+000 (00) 000-00-00');
    }
    return SizedBox(
      height: 44,
      width: MediaQuery.of(context1).size.width - 60,
      child: TextField(
        enabled: !disabled,
        obscureText: icon == Icons.lock ? obscure! : false,
        cursorColor: AppColors.blue,
        controller: controller,
        style: errorState ? AppTextStyles.style7_1(context) : AppTextStyles.style7(context),
        onChanged: (v) {
          switch (pageName) {
            case '/sign_in_page':
              context1.read<sign_in.SignInBloc>().add(sign_in.SignInChangeEvent());
              break;
            case '/sign_up_page':
              context1.read<sign_up.SignUpBloc>().add(sign_up.SignUpChangeEvent());
              break;
          }
        },
        onTap: () {
          switch (pageName) {
            case '/sign_in_page':
              context1.read<sign_in.SignInBloc>().add(sign_in.SignInChangeEvent());
              break;
            case '/sign_up_page':
              context1.read<sign_up.SignUpBloc>().add(sign_up.SignUpChangeEvent());
              break;
          }
        },
        onSubmitted: (v) {
          switch (pageName) {
            case '/sign_in_page':
              context1.read<sign_in.SignInBloc>().add(sign_in.OnSubmittedEvent(password: icon == Icons.lock));
              break;
            case '/sign_up_page':
              context1
                  .read<sign_up.SignUpBloc>()
                  .add(sign_up.OnSubmittedEvent(rePassword: actionDone,
                  fullName: icon == Icons.person, password: !actionDone && icon == Icons.lock));
              break;
          }
        },
        textInputAction: actionDone ? TextInputAction.done : TextInputAction.next,
        keyboardType: keyboard,
        focusNode: focus,
        inputFormatters: icon == Icons.phone ? [phoneInputFormatter!] : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          error: errorState ? const SizedBox.shrink() : null,
          prefixIcon: SizedBox(
            width: icon == Icons.phone && (controller.text.isNotEmpty || focus.hasFocus || focusCountry) ? 121 : 20,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(icon, color: errorState ? AppColors.red
                      : controller.text.isNotEmpty || focus.hasFocus ? AppColors.blue : AppColors.darkGrey),
                ),

                // #countryies
                icon == Icons.phone && (controller.text.isNotEmpty || focus.hasFocus || focusCountry)
                    ? Expanded(
                        flex: 3,
                        child: CountryDropdown(
                          itemHeight: 52,
                          triggerOnCountrySelectedInitially: false,
                          selectedItemBuilder: (phoneCountryData) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '+${phoneCountryData.phoneCode}',
                              ),
                            );
                          },
                          listItemBuilder: (phoneCountryData) {
                            switch (pageName) {
                              case '/sign_in_page':
                                context1.read<sign_in.SignInBloc>().add(sign_in.SignInOnTapCountryButtonEvent());
                                break;
                              case '/sign_up_page':
                                context1.read<sign_up.SignUpBloc>().add(sign_up.SignUpOnTapCountryButtonEvent());
                                break;
                            }
                            return PopScope(
                              canPop: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: CountryFlag(
                                      countryId: phoneCountryData.countryCode!,
                                    ),
                                  ),
                                  Text(
                                    phoneCountryData.country ?? '',
                                    style: AppTextStyles.style17(context),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                          onCountrySelected: (countryData) {
                            switch (pageName) {
                              case '/sign_in_page':
                                context1.read<sign_in.SignInBloc>().add(sign_in.SignInCountryEvent(countryData: countryData));
                                break;
                              case '/sign_up_page':
                                context1.read<sign_up.SignUpBloc>().add(sign_up.SignUpCountryEvent(countryData: countryData));
                                break;
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            border: myInputBorder(color1: AppColors.transparent),
                            enabledBorder: myInputBorder(color1: AppColors.transparent),
                            errorBorder: myInputBorder(color1: AppColors.transparent),
                            focusedBorder: myInputBorder(color1: AppColors.transparent),
                          ),
                          style: errorState ? AppTextStyles.style7_1(context) : AppTextStyles.style7(context),
                          icon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.expand_circle_down_outlined, size: 18, color: errorState ? AppColors.red : AppColors.blue),
                          ),
                          dropdownColor: AppColors.darker,
                          iconEnabledColor: controller.text.isNotEmpty || focus.hasFocus ? AppColors.blue : AppColors.darkGrey,
                          initialCountryData: countryData,
                          filter: PhoneCodes.findCountryDatasByCountryCodes(countryIsoCodes: countryIsoCodes),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          suffixIcon: SizedBox(
            height: 44,
            width: (controller.text.isNotEmpty || focus.hasFocus) ? icon == Icons.lock ? 96 : 40 : 1,
            child: Row(
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
                              context1.read<sign_in.SignInBloc>().add(sign_in.EyeEvent());
                              break;
                            case '/sign_up_page':
                              {
                                if (actionDone) {
                                  context1.read<sign_up.SignUpBloc>().add(sign_up.RePasswordEyeEvent());
                                } else {
                                  context1.read<sign_up.SignUpBloc>().add(sign_up.PasswordEyeEvent());
                                }
                                break;
                              }
                          }
                        },
                        icon: Icon(
                          obscure! ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                          color: errorState ? AppColors.red : AppColors.blue,
                        ),
                      )
                    : const SizedBox.shrink(),

                // #error_button_and_done
                controller.text.isNotEmpty || focus.hasFocus
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => !suffixIc ? Utils.mySnackBar(context: context1, txt: snackBarTxt, errorState: true) : {},
                        icon: suffixIc && !errorState
                            ? Icon(Icons.done, color: AppColors.blue)
                            : const Icon(Icons.error_outline, color: AppColors.red))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          labelText: labelTxt,
          hintText: hintTxt,
          hintStyle: AppTextStyles.style6(context),
          labelStyle: errorState ? AppTextStyles.style3_1(context) : controller.text.isNotEmpty || focus.hasFocus ? AppTextStyles.style3(context) : AppTextStyles.style6(context),
          border: myInputBorder(color1: AppColors.blue),
          enabledBorder: myInputBorder(
            color1: AppColors.blue,
            color2: AppColors.transparentBlue,
            itsColor1: controller.text.isNotEmpty || focus.hasFocus,
          ),
          disabledBorder: myInputBorder(color1: AppColors.blue),
          errorBorder: myInputBorder(color1: AppColors.red),
          focusedBorder: myInputBorder(color1: AppColors.blue),
        ),
      ),
    );
  }
}

TextButton myTextButton(
    {required BuildContext context, required String? assetIc, required Function() onPressed, required String txt}) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      overlayColor: MaterialStateProperty.all(AppColors.transparentBlue),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        assetIc != null
            ? SizedBox(height: 25, child: Image(image: AssetImage('assets/icons/ic_$assetIc.png')))
            : const SizedBox.shrink(),
        Text(' $txt', style: AppTextStyles.style9(context)),
      ],
    ),
  );
}

OutlineInputBorder myInputBorder({required Color color1, bool itsColor1 = true, Color? color2}) {
  return OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(width: 1.2, color: itsColor1 ? color1 : color2!),
  );
}

Container myIsLoading(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: AppColors.transparentBlack,
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.transparentBlue,
    ),
  );
}

class MyButton extends StatelessWidget {
  final bool enable;
  final String text;
  final Function function;
  final DisabledAction? disabledAction;

  const MyButton({
    super.key,
    required this.enable,
    required this.text,
    required this.function,
    this.disabledAction,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (enable) {
          function();
        } else {
          if (disabledAction != null) {
            Utils.mySnackBar(txt: disabledAction!.text, context: disabledAction!.context, errorState: true);
          }
        }
      },
      color: enable ? AppColors.blue : AppColors.transparentBlue,
      minWidth: double.infinity,
      height: 48,
      elevation: 0,
      highlightColor: AppColors.transparentBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: enable ? AppTextStyles.style4(context).copyWith(color: Colors.white) : AppTextStyles.style5(context)),
    );
  }
}

class MyFilterButton extends StatelessWidget {
  final bool enable;
  final String text;
  final Function function;

  const MyFilterButton({
    super.key,
    required this.enable,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => function(),
      color: enable ? AppColors.blue : AppColors.transparentBlue,
      minWidth: double.infinity,
      height: 40,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: enable ? AppTextStyles.style19(context) : AppTextStyles.style19_0(context)),
    );
  }
}

class DisabledAction {
  final String text;
  final BuildContext context;

  DisabledAction({required this.text, required this.context});
}
