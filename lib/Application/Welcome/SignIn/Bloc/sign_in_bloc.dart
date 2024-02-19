import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';

import '../../../../Data/Service/google_sign_in_service.dart';
import '../../../../Data/Service/lang_service.dart';
import '../../SignUp/View/sign_up_page.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  Language selectedLang = LangService.getLanguage;
  bool rememberMe = false;
  bool obscure = true;
  bool phoneSuffix = false;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  bool simple = false;
  bool country = false;
  int selectButton = 0;
  FocusNode focusPhone = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  ScrollController scrollController = ScrollController();
  PhoneInputFormatter phoneInputFormatter = PhoneInputFormatter(
    defaultCountryCode: 'UZ',
  );
  PhoneCountryData countryData = PhoneCountryData.fromMap({
    'country': 'Uzbekistan',
    'countryRU': 'Узбекистан',
    'internalPhoneCode': '998',
    'countryCode': 'UZ',
    'phoneMask': '+000 (00) 000-00-00',
  });

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SignInBloc()
      : super(SignInEnterState(
            selectButton: 0,
            simple: false,
            obscure: false,
            rememberMe: true,
            phone: false,
            email: false,
            password: false,
            passwordSuffix: false,
            emailSuffix: false,
            phoneSuffix: false)) {
    on<FlagEvent>(pressFlagButton);
    on<SelectLanguageEvent>(pressLanguageButton);
    on<SignInChangeEvent>(change);
    on<OnSubmittedEvent>(onSubmitted);
    on<PhoneButtonEvent>(pressPhone);
    on<EmailButtonEvent>(pressEmail);
    on<EyeEvent>(pressEye);
    on<SignInButtonEvent>(pressSignIn);
    on<RememberMeEvent>(pressRememberMe);
    on<ForgotPasswordEvent>(pressForgotPassword);
    on<FaceBookEvent>(pressFacebook);
    on<GoogleEvent>(pressGoogle);
    on<SignUpEvent>(pressSignUp);
    on<SignInCountryEvent>(pressCountry);
    on<SignInOnTapCountryButtonEvent>(pressCountryDropdown);
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(SignInFlagState());
    emit(SignInEnterState(
        selectButton: selectButton,
        simple: simple,
        passwordSuffix: passwordSuffix,
        emailSuffix: emailSuffix,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe,
    ));
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignInState> emit) async {
    country = false;
    if(!event.password) {
      focusPhone.unfocus();
      focusEmail.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusPassword.requestFocus();
    }
    emit(SignInEnterState(
        selectButton: 0,
        simple: simple,
        passwordSuffix: passwordSuffix,
        emailSuffix: emailSuffix,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe));
  }

  Future<void> pressPhone(PhoneButtonEvent event, Emitter<SignInState> emit) async {
    selectButton = 0;
    focusEmail.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic);
    focusPhone.requestFocus();
    emit(SignInEnterState(
        selectButton: 0,
        simple: simple,
        passwordSuffix: passwordSuffix,
        emailSuffix: emailSuffix,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe));
  }

  Future<void> pressEmail(EmailButtonEvent event, Emitter<SignInState> emit) async {
    selectButton = 1;
    focusPhone.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(event.width - 60,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic);
    focusEmail.requestFocus();
    emit(SignInEnterState(
        selectButton: 1,
        simple: simple,
        passwordSuffix: passwordSuffix,
        emailSuffix: emailSuffix,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe));
  }

  Future<void> pressSignIn(SignInButtonEvent event, Emitter<SignInState> emit) async {
    // todo code
  }

  Future<void> pressForgotPassword(ForgotPasswordEvent event, Emitter<SignInState> emit) async {
    // todo code
  }

  Future<void> pressGoogle(GoogleEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState(
      password: passwordSuffix,
      obscure: obscure,
      email: emailSuffix,
      rememberMe: rememberMe,
    ));

    UserCredential userCredential = await signInWithGoogle();
    String? email = userCredential.user?.email;
    if (email != null) {
      emailController.text = email;
      emailSuffix = true;
      selectButton = 1;
      focusPhone.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      await scrollController.animateTo(event.width - 60,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic);
    }

    emit(SignInEnterState(
      simple: simple,
      selectButton: selectButton,
      phone: phoneNumberController.text.trim().isNotEmpty,
      email: emailController.text.trim().isNotEmpty,
      password: passwordController.text.trim().isNotEmpty,
      obscure: obscure,
      rememberMe: rememberMe,
      phoneSuffix: phoneSuffix,
      emailSuffix: emailSuffix,
      passwordSuffix: passwordSuffix,
    ));
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignInState> emit) async {
    print('facebook');
    final fbLogin = FacebookLogin();
    // final FacebookLoginResult result = await fbLogin.logIn(customPermissions: ["email"]);
    // final String? token = result.accessToken?.token;
    // final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    // final profile = jsonDecode(response.body);
    // print(profile);

    // Create an instance of FacebookLogin
    // final fb = FacebookLogin();

// Log in
//     final res = await fb.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);

    String? email = await fbLogin.getUserEmail();
    print(email);
  }

  Future<void> pressCountry(SignInCountryEvent event, Emitter<SignInState> emit) async {
    country = false;
    phoneNumberController.text = '';
    countryData = event.countryData;
    phoneInputFormatter = PhoneInputFormatter(defaultCountryCode: event.countryData.countryCode);
    focusPhone.unfocus();
    focusEmail.unfocus();
    focusPassword.unfocus();
    simple = !simple;
    emit(SignInEnterState(
        selectButton: selectButton,
        simple: simple,
        email: emailController.text
            .trim()
            .isNotEmpty,
        password: passwordController.text
            .trim()
            .isNotEmpty,
        phone: phoneNumberController.text.isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe,
        phoneSuffix: phoneSuffix,
        emailSuffix: emailSuffix,
        passwordSuffix: passwordSuffix));
    await Future.delayed(const Duration(milliseconds: 30));
    focusPhone.requestFocus();
  }

  void pressFlagButton(FlagEvent event, Emitter emit) {
    emit(SignInFlagState());
  }

  void pressCountryDropdown(SignInOnTapCountryButtonEvent event, Emitter<SignInState> emit) {
    country = true;
    emit(SignInEnterState(
        selectButton: selectButton,
        simple: simple,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        phone: phoneNumberController.text.isNotEmpty || true,
        obscure: obscure,
        rememberMe: rememberMe,
        phoneSuffix: phoneSuffix,
        emailSuffix: emailSuffix,
        passwordSuffix: passwordSuffix));
  }

  void change(SignInChangeEvent event, Emitter<SignInState> emit) {
    country = false;
    if (focusPassword.hasFocus) country = false;
    if (phoneNumberController.text.length != countryData.phoneMaskWithoutCountryCode.length) {
      phoneSuffix = false;
    }
    if (!phoneSuffix && phoneNumberController.text.length == countryData.phoneMaskWithoutCountryCode.length) {
      phoneSuffix = true;
    }

    if (emailController.text.contains('@') &&
        emailController.text.contains('.') &&
        emailController.text
            .substring(0, emailController.text.indexOf('@'))
            .isNotEmpty &&
        emailController.text
            .substring(emailController.text.indexOf('@') + 1,
                emailController.text.indexOf('.'))
            .isNotEmpty &&
        emailController.text
            .substring(emailController.text.indexOf('.') + 1,
                emailController.text.length)
            .isNotEmpty) {
      emailSuffix = true;
    } else {
      emailSuffix = false;
    }

    if (passwordController.text.trim().length > 5 &&
        (passwordController.text.contains(RegExp('[a-z]')) ||
            passwordController.text.contains(RegExp('[A-Z]'))) &&
        passwordController.text.contains(RegExp('[0-9]')) &&
        !passwordController.text.trim().contains(' ')) {
      passwordSuffix = true;
    } else {
      passwordSuffix = false;
    }
    simple = !simple;
    emit(SignInEnterState(
        selectButton: selectButton,
        simple: simple,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        phone: phoneNumberController.text.isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe,
        phoneSuffix: phoneSuffix,
        emailSuffix: emailSuffix,
        passwordSuffix: passwordSuffix));
  }

  void pressEye(EyeEvent event, Emitter<SignInState> emit) {
    obscure = !obscure;
    emit(SignInEnterState(
        simple: simple,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        selectButton: selectButton,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe,
        emailSuffix: emailSuffix,
        passwordSuffix: passwordSuffix));
  }

  void pressRememberMe(RememberMeEvent event, Emitter<SignInState> emit) {
    rememberMe = !rememberMe;
    emit(SignInEnterState(
        simple: simple,
        phoneSuffix: phoneSuffix,
        phone: phoneNumberController.text.trim().isNotEmpty,
        selectButton: selectButton,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        rememberMe: rememberMe,
        emailSuffix: emailSuffix,
        passwordSuffix: passwordSuffix));
  }

  void pressSignUp(SignUpEvent event, Emitter<SignInState> emit) {
    Navigator.pushReplacementNamed(event.context, SignUpPage.id);
  }
}
