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
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 91,
            backgroundColor: AppColors.black,
            surfaceTintColor: AppColors.black,

            // #flag
            actions: [
              MyFlagButton(
                  currentLang: bloc.selectedLang,
                  pageContext: context,
                  pageName: id)
            ],

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
                              MyPhoneTextField(
                                bloc: bloc,
                                state: state,
                                suffixIc: bloc.phoneSuffix,
                                snackBarTxt: 'snackBar'.tr(),
                                labelTxt: 'phone_num'.tr(),
                                keyboard: TextInputType.phone,
                                hintTxt: '(00) 000-00-00',
                                errorTxt: 'invalid_phone'.tr(),
                                errorState: state is SignInErrorState,
                                enterStateAndField: state is SignInEnterState && state.phone,
                                context1: context,
                                focus: bloc.focusPhone,
                                icon: Icons.phone,
                                controller: bloc.phoneNumberController,
                                pageName: id,
                              ),
                              // #email
                              MyTextField(
                                pageName: id,
                                controller: bloc.emailController,
                                enterStateAndField: state is SignInEnterState && state.email,
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
                              /*SizedBox(
                                height: 44,
                                width: MediaQuery.of(context).size.width - 60,
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: TextField(
                                    controller: bloc.emailController,
                                    style: AppTextStyles.style7,
                                    onChanged: (v) => context
                                        .read<SignInBloc>()
                                        .add(SignInChangeEvent()),
                                    onTap: () => context
                                        .read<SignInBloc>()
                                        .add(SignInChangeEvent()),
                                    onSubmitted: (v) => context
                                        .read<SignInBloc>()
                                        .add(OnSubmittedEvent()),
                                    textInputAction: TextInputAction.done,
                                    focusNode: bloc.focusEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 20,
                                          right: 0),
                                      suffixIconConstraints:
                                          const BoxConstraints(maxWidth: 48),
                                      errorText: state is SignInErrorState
                                          ? 'invalid_email'.tr()
                                          : null,
                                      prefixIcon: Icon(Icons.mail,
                                          color: state is SignInEnterState &&
                                                      state.email ||
                                                  bloc.focusEmail.hasFocus
                                              ? AppColors.blue
                                              : AppColors.darkGrey),
                                      suffixIcon: bloc.emailController.text
                                                  .isNotEmpty ||
                                              bloc.focusEmail.hasFocus
                                          ? IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () => !bloc.emailSuffix
                                                  ? mySnackBar(
                                                      context: context,
                                                      txt: 'snackBar'.tr())
                                                  : {},
                                              splashRadius:
                                                  bloc.emailSuffix ? 0.1 : 20,
                                              icon: bloc.emailSuffix
                                                  ? const Icon(Icons.done,
                                                      color: AppColors.blue)
                                                  : const Icon(
                                                      Icons.error_outline,
                                                      color: AppColors.red),
                                            )
                                          : const SizedBox.shrink(),
                                      labelText: 'email_address'.tr(),
                                      hintText: 'aaabbbccc@dddd.eee',
                                      labelStyle: bloc.emailController.text
                                                  .isNotEmpty ||
                                              bloc.focusEmail.hasFocus
                                          ? AppTextStyles.style3
                                          : AppTextStyles.style6,
                                      hintStyle: AppTextStyles.style6,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: state is SignInEnterState &&
                                                    state.email
                                                ? AppColors.blue
                                                : AppColors.disableBlue),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                            width: 1.2, color: AppColors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/
                            ]),
                          ),
                        ),

                        // #select_buttons
                        Row(
                          children: [

                            // #phone
                            SelectButton(
                                context: context,
                                function: () =>
                                    bloc.add(PhoneButtonEvent(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width)),
                                text: 'phone'.tr(),
                                select: bloc.selectButton == 0),
                            const Spacer(),

                            // #or
                            Text('or'.tr(), style: AppTextStyles.style2),

                            // #email
                            const Spacer(),
                            SelectButton(
                                context: context,
                                function: () =>
                                    bloc.add(EmailButtonEvent(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width)),
                                text: 'email'.tr(),
                                select: bloc.selectButton == 1),
                          ],
                        ),
                      ],
                    ),

                    // #password
                    MyTextField(
                      pageName: id,
                      controller: bloc.passwordController,
                      enterStateAndField: state is SignInEnterState && state.password,
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
                              onChanged: (v) =>
                                  context
                                      .read<SignInBloc>()
                                      .add(RememberMeEvent()),
                              fillColor:
                              MaterialStateProperty.all(AppColors.blue),
                              value: bloc.rememberMe,
                              shape: const StadiumBorder(
                                  side: BorderSide(color: AppColors.blue)),
                            ),
                            TextButton(
                                onPressed: () =>
                                    context
                                        .read<SignInBloc>()
                                        .add(RememberMeEvent()),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      AppColors.disableBlue),
                                ),
                                child: Text('remember_me'.tr(),
                                    style: AppTextStyles.style9)),
                          ],
                        ),

                        // #log_in
                        (bloc.emailSuffix || bloc.phoneSuffix) &&
                            bloc.passwordSuffix
                            ? MaterialButton(
                          onPressed: () =>
                              context
                                  .read<SignInBloc>()
                                  .add(SignInButtonEvent()),
                          color: AppColors.blue,
                          minWidth: double.infinity,
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'log_in'.tr(),
                            style: AppTextStyles.style4,
                          ),
                        )
                            : Container(
                          height: 48,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.disableBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'log_in'.tr(),
                            style: AppTextStyles.style5,
                          ),
                        ),

                        // #forgot_the_password
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                AppColors.disableBlue),
                          ),
                          onPressed: () =>
                              context
                                  .read<SignInBloc>()
                                  .add(ForgotPasswordEvent()),
                          child:
                          Text('forgot'.tr(), style: AppTextStyles.style9),
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
                            onPressed: () =>
                                context.read<SignInBloc>().add(FaceBookEvent()),
                            context: context,
                            assetIc: 'facebook',
                            txt: 'Facebook'),
                        // #google
                        myTextButton(
                            onPressed: () =>
                                context.read<SignInBloc>().add(
                                    GoogleEvent(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width)),
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
                            ..onTap = () =>
                                context
                                    .read<SignInBloc>()
                                    .add(SignUpEvent(context: context)),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

