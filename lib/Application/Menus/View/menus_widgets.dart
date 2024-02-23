import 'package:flutter/material.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

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
            onPressed: () => bloc.add(MainChangeEvent(index: index)),
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
