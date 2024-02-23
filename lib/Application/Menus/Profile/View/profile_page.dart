import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/Profile/Bloc/profile_bloc.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

import '../../../Welcome/View/welcome_widgets.dart';

class ProfilePage extends StatelessWidget {
  static const id = '/profile_page';
  final MainBloc mainBloc;

  const ProfilePage({super.key, required this.mainBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(mainBloc: mainBloc),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        ProfileBloc bloc = context.read<ProfileBloc>();
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: AppBar(
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

                    // #profile_text
                    Text('profile'.tr(), style: AppTextStyles.style18),
                  ],
                ),
              ),

              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 188,
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // #full_name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.account_circle_rounded, color: AppColors.blue, size: 48),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(bloc.fullName, style: AppTextStyles.style3),
                                    Text('i_billing_user'.tr(), style: AppTextStyles.style19),
                                  ],
                                ),

                              ],
                            ),

                            // #date_of_sign_up
                            Row(
                              children: [
                                Text("${'date_sign'.tr()}:", style: AppTextStyles.style19),
                                const SizedBox(width: 10),
                                Text(bloc.dateSign, style: AppTextStyles.style23),
                              ],
                            ),

                            // #phone_number
                            Row(
                              children: [
                                Text("${'phone_num'.tr()}:", style: AppTextStyles.style19),
                                const SizedBox(width: 10),
                                Text(bloc.phoneNumber, style: AppTextStyles.style23),
                              ],
                            ),

                            // #email
                            Row(
                              children: [
                                Text("${'email'.tr()}:", style: AppTextStyles.style19),
                                const SizedBox(width: 10),
                                Text(bloc.email, style: AppTextStyles.style23),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // #theme
                      MyProfileButton(
                        bloc: bloc,
                        text: 'theme'.tr(),
                        function: () => context.read<ProfileBloc>().add(DarkModeEvent(darkMode: !bloc.darkMode)),
                        endElement: SizedBox(
                          height: 30,
                          child: ToggleButtons(
                            selectedColor: AppColors.white,
                            color: AppColors.darkGrey,
                            fillColor: AppColors.blue,
                            hoverColor: AppColors.red,
                            splashColor: AppColors.blue,
                            borderColor: AppColors.darkGrey,
                            borderWidth: 0.3,
                            borderRadius: BorderRadius.circular(6),
                            isSelected: [!bloc.darkMode, bloc.darkMode],
                            onPressed: (i) => context.read<ProfileBloc>().add(DarkModeEvent(darkMode: i == 1)),
                            children: const <Widget>[
                              Icon(CupertinoIcons.sun_max_fill, size: 20),
                              Icon(CupertinoIcons.moon_stars_fill, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // #language
                      MyProfileButton(
                        bloc: bloc,
                        text: 'current_lang'.tr(),
                        function: () => context.read<ProfileBloc>().add(LanguageEvent()),
                        endElement: Image(
                          image: AssetImage('assets/icons/ic_flag_${bloc.selectedLang.name}.png'),
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // #sign_out
                      MyProfileButton(
                        bloc: bloc,
                        text: 'sign_out'.tr(),
                        function: () => context.read<ProfileBloc>().add(SignOutEvent()),
                        endElement: const Icon(CupertinoIcons.square_arrow_right, size: 24, color: AppColors.red),
                      ),
                    ],
                  ),
              ),
            ),

            // #choose_language_screen
            if (state is ProfileLangState)
              MyProfileScreen(
                bloc: bloc,
                textTitle: 'choose_lang'.tr(language: bloc.selectedLang),
                textCancel: 'cancel'.tr(language: bloc.selectedLang),
                textDone: 'done'.tr(language: bloc.selectedLang),
                functionCancel: () => context.read<ProfileBloc>().add(CancelEvent()),
                functionDone: () => context.read<ProfileBloc>().add(DoneEvent(context: context)),
                // #languages
                child: SizedBox(
                  height: 175,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    padding: EdgeInsets.zero,
                    itemBuilder: (c, index) {
                      return RadioListTile(
                          activeColor: AppColors.blue,
                          hoverColor: AppColors.blue,
                          overlayColor: const MaterialStatePropertyAll(AppColors.disableBlue),
                          selectedTileColor: AppColors.blue,
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: EdgeInsets.zero,
                          secondary: Image(
                            image: AssetImage('assets/icons/ic_flag_${bloc.lang[index].name}.png'),
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                          title: Text('button_$index'.tr(), style: AppTextStyles.style23),
                          selected: bloc.lang[index] == bloc.selectedLang,
                          value: bloc.lang[index],
                          groupValue: bloc.selectedLang,
                          onChanged: (value) => context.read<ProfileBloc>()
                              .add(SelectLanguageEvent(lang: value as Language)));
                    },
                  ),
                ),
              ),

            // #sign_out_screen
            if (state is ProfileSignOutState)
              MyProfileScreen(
                bloc: bloc,
                textTitle: 'sign_out'.tr(),
                textCancel: 'cancel'.tr(),
                textDone: 'confirm'.tr(),
                functionCancel: () => context.read<ProfileBloc>().add(CancelEvent()),
                functionDone: () => context.read<ProfileBloc>().add(ConfirmEvent()),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('confirm_sign_out'.tr(), style: AppTextStyles.style23),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
    required this.bloc,
    required this.textTitle,
    required this.textCancel,
    required this.textDone,
    required this.functionCancel,
    required this.functionDone,
    required this.child,
  });

  final ProfileBloc bloc;
  final String textTitle;
  final String textCancel;
  final String textDone;
  final Function functionCancel;
  final Function functionDone;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        // #backgoround
        InkWell(
          onTap: () => functionCancel(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectButton(
                      context: context,
                      text: textCancel,
                      function: () => functionCancel(),
                      select: false,
                    ),

                    SelectButton(
                      context: context,
                      text: textDone,
                      function: () => functionDone(),
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
  final ProfileBloc bloc;
  final Function function;
  final String text;
  final Widget endElement;

  const MyProfileButton({
    super.key,
    required this.bloc,
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
