import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Data/Service/lang_service.dart';


import '../../../../Configuration/app_text_styles.dart';
import '../../View/welcome_widgets.dart';
import '../Bloc/start_bloc.dart';
import '/Configuration/app_colors.dart';

class StartPage extends StatelessWidget {
  static const id = '/start_page';

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StartBloc(),
      child: BlocBuilder<StartBloc, StartState>(builder: (context, state) {
          StartBloc bloc = context.read<StartBloc>();
          return Scaffold(
              backgroundColor: AppColors.black,
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 91,
                backgroundColor: AppColors.black,

                // #flag
                actions: [
                 MyFlagButton(currentLang: bloc.selectedLang, pageContext: context, pageName: id),
                ],

                // #IBilling
                title: const Text('IBilling', style: AppTextStyles.style0_1),
                leadingWidth: 60,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: const TabBarView(
                            children: [
                              StartView(img: 1),
                              StartView(img: 2),
                              StartView(img: 3),
                            ],
                          ),
                        ),
                        const TabPageSelector(
                          indicatorSize: 8,
                          color: AppColors.darkGrey,
                          selectedColor: AppColors.blue,
                          borderStyle: BorderStyle.none,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 48, right: 24, left: 24),
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // #next
                        MaterialButton(
                          onPressed: () => context
                              .read<StartBloc>()
                              .add(NextEvent(context: context)),
                          color: AppColors.blue,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          height: 48,
                          child:
                              Text('log_in'.tr(), style: AppTextStyles.style4),
                        ),
                        const Spacer(),

                        // #text
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'log_info'.tr(),
                                style: AppTextStyles.style2,
                              ),

                              // #terms_of_use
                              TextSpan(
                                text: 'terms'.tr(),
                                style: AppTextStyles.style9,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context
                                      .read<StartBloc>()
                                      .add(FlagEvent(context: context)),
                              ),
                              TextSpan(
                                text: 'and'.tr(),
                                style: AppTextStyles.style2,
                              ),

                              // #privacy_policy
                              TextSpan(
                                text: 'policy'.tr(),
                                style: AppTextStyles.style9,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context
                                      .read<StartBloc>()
                                      .add(FlagEvent(context: context)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class StartView extends StatelessWidget {
  final int img;

  const StartView({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // #images_tabview
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.transparentGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Image(
                      image: AssetImage('assets/images/img_$img.png'),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // #text
                  Text(
                    'welcome_$img'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.style1,
                  ),
                  Text(
                    'welcome_info'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.style2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
