import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

import '../../../../Configuration/app_colors.dart';
import '../../../../Configuration/app_text_styles.dart';
import '../../View/welcome_widgets.dart';
import '../Bloc/sign_in_bloc.dart';

class SignInPage extends StatelessWidget {
  static const id = '/sign_in_page';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
        SignInBloc bloc = context.read<SignInBloc>();
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
                actions: [MyFlagButton(
                      currentLang: bloc.selectedLang,
                      pageContext: context,
                      pageName: id)],

                // #IBilling
                title: const Text('IBilling', style: AppTextStyles.style0_1),
                leadingWidth: 60,
              ),

              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 122,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // #log_in_text
                        Text(
                          'log_to_acc'.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.style16,
                        ),

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
                                    errorState: state is SignInErrorState,
                                    suffixIc: bloc.phoneSuffix,
                                    keyboard: TextInputType.phone,
                                    focus: bloc.focusPhone,
                                    errorTxt: 'invalid_phone'.tr(),
                                    context1: context,
                                    icon: Icons.phone,
                                    hintTxt: bloc.countryData.phoneMaskWithoutCountryCode,
                                    labelTxt: 'phone_num'.tr(),
                                    snackBarTxt: 'snackBar'.tr(),
                                  ),

                                  // #email
                                  MyTextField(
                                    pageName: id,
                                    controller: bloc.emailController,
                                    errorState: state is SignInErrorState,
                                    suffixIc: bloc.emailSuffix,
                                    keyboard: TextInputType.emailAddress,
                                    focus: bloc.focusEmail,
                                    errorTxt: 'invalid_email'.tr(),
                                    context1: context,
                                    icon: Icons.mail,
                                    hintTxt: 'aaabbbccc@dddd.eee',
                                    labelTxt: 'email_address'.tr(),
                                    snackBarTxt: 'snackBar'.tr(),
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
                                  function: () => bloc.add(PhoneButtonEvent(width: MediaQuery.of(context).size.width)),
                                  text: 'phone'.tr(),
                                  select: bloc.selectButton == 0,
                                ),

                                // #or
                                Text('or'.tr(), style: AppTextStyles.style2),

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

                        // #password
                        MyTextField(
                          pageName: id,
                          controller: bloc.passwordController,
                          errorState: state is SignInErrorState,
                          suffixIc: bloc.passwordSuffix,
                          keyboard: TextInputType.text,
                          focus: bloc.focusPassword,
                          errorTxt: 'invalid_password'.tr(),
                          context1: context,
                          icon: Icons.lock,
                          hintTxt: '123abc',
                          labelTxt: 'password'.tr(),
                          snackBarTxt: 'snackBar'.tr(),
                          obscure: bloc.obscure,
                        ),

                        // #buttons
                        Column(
                          children: [

                            // #remember_me
                            Row(
                              children: [
                                Checkbox(
                                  onChanged: (v) => context.read<SignInBloc>().add(RememberMeEvent()),
                                  fillColor: MaterialStateProperty.all(AppColors.blue),
                                  value: bloc.rememberMe,
                                  shape: const StadiumBorder(side: BorderSide(color: AppColors.blue)),
                                ),
                                myTextButton(
                                  context: context,
                                  assetIc: null,
                                  onPressed: () => context
                                      .read<SignInBloc>()
                                      .add(RememberMeEvent()),
                                  txt: 'remember_me'.tr(),
                                )
                              ],
                            ),

                            // #log_in
                            MyButton(
                              disabledAction: DisabledAction(context: context, text: 'fill_all_forms'.tr()),
                              function: () => context.read<SignInBloc>().add(SignInButtonEvent()),
                              enable: (bloc.emailSuffix || bloc.phoneSuffix) && bloc.passwordSuffix,
                              text: 'log_in'.tr(),
                            ),

                            // #forgot_the_password
                            myTextButton(
                              context: context,
                              txt: 'forgot'.tr(),
                              assetIc: null,
                              onPressed: () => context.read<SignInBloc>().add(ForgotPasswordEvent())
                            ),
                          ],
                        ),

                        // #or_continue_with
                        Text('or_continue_with'.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.style2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            // #facebook
                            myTextButton(
                                onPressed: () => context.read<SignInBloc>().add(FaceBookEvent()),
                                context: context,
                                assetIc: 'facebook',
                                txt: 'Facebook'),

                            // #or
                            Text('or'.tr(), style: AppTextStyles.style2),

                            // #google
                            myTextButton(
                                onPressed: () => context.read<SignInBloc>().add(GoogleEvent(width: MediaQuery.of(context).size.width)),
                                context: context,
                                assetIc: 'google',
                                txt: 'Google'),
                          ],
                        ),

                        // #sing_up
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'dont_have_an_account'.tr(),
                              style: AppTextStyles.style2,
                            ),
                            TextSpan(
                              text: 'sign_up'.tr(),
                              style: AppTextStyles.style9,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context
                                    .read<SignInBloc>()
                                    .add(SignUpEvent(context: context)),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // #is_loading
            if (state is SignInLoadingState)
              myIsLoading(context),
          ],
        );
      }),
    );
  }
}
