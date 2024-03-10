import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

import '../../../../Configuration/app_colors.dart';
import '../../../../Configuration/app_text_styles.dart';
import '../../View/welcome_widgets.dart';
import '../Bloc/sign_up_bloc.dart';

class SignUpPage extends StatelessWidget {
  static const id = '/sign_up_page';

  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
        SignUpBloc bloc = context.read<SignUpBloc>();
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.black,

              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 91,
                backgroundColor: AppColors.black,
                surfaceTintColor: AppColors.black,

                // #flag
                actions: [MyFlagButton(currentLang: bloc.selectedLang, pageContext: context, pageName: id)],

                // #IBilling
                title: Text('IBilling', style: AppTextStyles.style0_1(context)),
                leadingWidth: 60,
              ),

              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 122,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // #sign_up_for_free
                            Text('sign_up_for_free'.tr(), textAlign: TextAlign.center, style: AppTextStyles.style1(context)),

                            Column(
                              children: [
                                // #text_fields
                                SizedBox(
                                  height: 60,
                                  child: SingleChildScrollView(
                                    controller: bloc.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    physics: const NeverScrollableScrollPhysics(),
                                    child: Row(children: [
                                      // #phone
                                      MyTextField(
                                        focusCountry: bloc.country,
                                        phoneInputFormatter: bloc.phoneInputFormatter,
                                        countryData: bloc.countryData,
                                        pageName: id,
                                        controller: bloc.phoneNumberController,
                                        errorState: state is SignUpErrorState,
                                        suffixIc: bloc.phoneSuffix,
                                        keyboard: TextInputType.phone,
                                        focus: bloc.focusPhone,
                                        errorTxt: 'invalid_phone'.tr(),
                                        context1: context,
                                        icon: Icons.phone,
                                        hintTxt: bloc.countryData.phoneMaskWithoutCountryCode,
                                        labelTxt: 'phone_num'.tr(),
                                        snackBarTxt: 'fill_phone'.tr(),
                                      ),

                                      // #email
                                      MyTextField(
                                        disabled: bloc.googleOrFacebook,
                                        pageName: id,
                                        controller: bloc.emailController,
                                        errorState: state is SignUpErrorState,
                                        suffixIc: bloc.emailSuffix,
                                        keyboard: TextInputType.emailAddress,
                                        focus: bloc.focusEmail,
                                        errorTxt: 'invalid_email'.tr(),
                                        context1: context,
                                        icon: Icons.mail,
                                        hintTxt: 'aaabbbccc@dddd.eee',
                                        labelTxt: 'email_address'.tr(),
                                        snackBarTxt: 'fill_email'.tr(),
                                      ),
                                    ]),
                                  ),
                                ),

                                // #select_buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // #phone
                                    SelectButton(
                                      context: context,
                                      function: () => bloc.add(PhoneButtonEvent()),
                                      text: 'phone'.tr(),
                                      select: bloc.selectButton == 0,
                                    ),

                                    // #or
                                    Text('or'.tr(), style: AppTextStyles.style2(context)),

                                    // #email
                                    SelectButton(
                                      context: context,
                                      function: () => bloc.add(EmailButtonEvent(width: MediaQuery.of(context).size.width)),
                                      text: 'email'.tr(),
                                      select: bloc.selectButton == 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // #full_name
                            MyTextField(
                              pageName: id,
                              controller: bloc.fullNameController,
                              errorState: state is SignUpErrorState,
                              suffixIc: bloc.fullNameSuffix,
                              keyboard: TextInputType.name,
                              focus: bloc.focusFullName,
                              errorTxt: 'invalid_full_name'.tr(),
                              context1: context,
                              icon: Icons.person,
                              hintTxt: 'example_full_name'.tr(),
                              labelTxt: 'full_name'.tr(),
                              snackBarTxt: 'fill_full_name'.tr(),
                            ),

                            // #password
                            MyTextField(
                              pageName: id,
                              controller: bloc.passwordController,
                              errorState: state is SignUpErrorState,
                              suffixIc: bloc.passwordSuffix,
                              keyboard: TextInputType.visiblePassword,
                              focus: bloc.focusPassword,
                              errorTxt: 'invalid_password'.tr(),
                              context1: context,
                              icon: Icons.lock,
                              hintTxt: '123abc',
                              labelTxt: 'password'.tr(),
                              snackBarTxt: 'fill_password'.tr(),
                              obscure: bloc.obscurePassword,
                            ),

                            // #repeat_password
                            MyTextField(
                              pageName: id,
                              controller: bloc.rePasswordController,
                              errorState: state is SignUpErrorState,
                              suffixIc: bloc.rePasswordSuffix,
                              keyboard: TextInputType.visiblePassword,
                              focus: bloc.focusRePassword,
                              errorTxt: 'invalid_password'.tr(),
                              context1: context,
                              icon: Icons.lock,
                              hintTxt: '123abc',
                              labelTxt: 're_password'.tr(),
                              snackBarTxt: 'fill_re_password'.tr(),
                              obscure: bloc.obscureRePassword,
                              actionDone: true,
                            ),

                            // #sign_up
                            MyButton(
                              disabledAction: DisabledAction(context: context, text: 'fill_all_forms'.tr()),
                              text: 'sign_up'.tr(),
                              enable: (bloc.emailSuffix || bloc.phoneSuffix || bloc.googleOrFacebook) && bloc.fullNameSuffix
                                  && bloc.passwordSuffix && bloc.rePasswordSuffix,
                              function: () => context.read<SignUpBloc>().add(SignUpButtonEvent(context: context)),
                            ),

                            // #or_continue_with
                            Text(
                              'or_continue_with'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.style2(context),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // #facebook
                                myTextButton(
                                    onPressed: () => context.read<SignUpBloc>()
                                            .add(FaceBookEvent(width: MediaQuery.of(context).size.width, context: context)),
                                    context: context,
                                    assetIc: 'facebook',
                                    txt: 'Facebook',
                                ),

                                // #or
                                Text('or'.tr(), style: AppTextStyles.style2(context)),

                                // #google
                                myTextButton(
                                    onPressed: () => context.read<SignUpBloc>()
                                        .add(GoogleEvent(width: MediaQuery.of(context).size.width, context: context)),
                                    context: context,
                                    assetIc: 'google',
                                    txt: 'Google',
                                ),
                              ],
                            ),

                            // #sing_in
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'already_account'.tr(),
                                  style: AppTextStyles.style2(context),
                                ),
                                TextSpan(
                                  text: 'log_in'.tr(),
                                  style: AppTextStyles.style9(context),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.read<SignUpBloc>().add(SignInEvent(context: context)),
                                ),
                              ]),
                            ),
                          ],
                        ),

                        // #verify_phone
                        if (state is SignUpVerifyPhoneState || bloc.sms || bloc.email)
                          Container(
                            alignment: Alignment.center,
                            color: AppColors.black,
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                // #sign_up_for_free
                                Text(bloc.selectButton == 0 ? 'enter_sms_code'.tr() : 'verify_email'.tr(),
                                    textAlign: TextAlign.center, style: AppTextStyles.style1(context)),
                                const SizedBox(height: 50),

                                // #sms_code
                                if (bloc.selectButton == 0)
                                  Column(
                                    children: [
                                      MyTextField(
                                        pageName: id,
                                        controller: bloc.smsCodeController,
                                        errorState: state is SignUpErrorState,
                                        suffixIc: bloc.smsSuffix,
                                        keyboard: TextInputType.number,
                                        focus: bloc.focusSms,
                                        errorTxt: 'invalid_full_name'.tr(),
                                        context1: context,
                                        icon: Icons.sms,
                                        hintTxt: '000000',
                                        labelTxt: 'SMS code',
                                        snackBarTxt: 'snackBar'.tr(),
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),

                                // #confirm
                                MyButton(
                                  disabledAction: DisabledAction(text: 'fill_sms'.tr(), context: context),
                                    enable: bloc.smsSuffix || bloc.selectButton == 1,
                                    text: 'confirm'.tr(),
                                    function: () => context.read<SignUpBloc>().add(SignUpConfirmEvent(context: context)),
                                ),
                                const SizedBox(height: 20),

                                // #cancel
                                MyButton(
                                    enable: true,
                                    text: 'cancel'.tr(),
                                    function: () => context.read<SignUpBloc>().add(SignUpCancelEvent()),
                                ),

                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // #is_loading
            if (state is SignUpLoadingState) myIsLoading(context),
          ],
        );
      }),
    );
  }
}