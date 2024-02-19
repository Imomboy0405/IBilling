import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';

import '../../../../Data/Model/login_model.dart';
import '../../../../Data/Service/google_sign_in_service.dart';
import '../../../../Data/Service/lang_service.dart';
import '../../../../Data/Service/network_service.dart';
import '../../SignIn/View/sign_in_page.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  Language selectedLang = LangService.getLanguage;
  bool rememberMe = false;
  bool obscure = true;
  bool phoneSuffix = false;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  bool fullNameSuffix = false;
  bool simple = false;
  bool country = false;
  FocusNode focusPhone = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusFullName = FocusNode();
  int selectButton = 0;
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  ScrollController scrollController = ScrollController();

  SignUpBloc()
      : super(SignUpEnterState(
            simple: false,
            phone: false,
            obscure: false,
            email: false,
            password: false,
            fullName: false)) {
    on<SignUpChangeEvent>(change);
    on<OnSubmittedEvent>(onSubmitted);
    on<EyeEvent>(pressEye);
    on<SignUpButtonEvent>(pressSignUp);
    on<RememberMeEvent>(pressRememberMe);
    on<FaceBookEvent>(pressFacebook);
    on<GoogleEvent>(pressGoogle);
    on<SignInEvent>(pressSignIn);
    on<PhoneButtonEvent>(pressPhone);
    on<EmailButtonEvent>(pressEmail);
    on<SelectLanguageEvent>(pressLanguageButton);
    on<SignUpOnTapCountryButtonEvent>(pressCountryDropdown);
    on<SignUpCountryEvent>(pressCountry);
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(SignUpFlagState());
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignUpState> emit) async {
    if (event.password) {
      focusPassword.unfocus();
    } else {
      if (!event.fullName) {
        focusEmail.unfocus();
        focusPhone.unfocus();
        country = false;
        await Future.delayed(const Duration(milliseconds: 30));
        focusFullName.requestFocus();
      } else {
        focusFullName.unfocus();
        await Future.delayed(const Duration(milliseconds: 30));
        focusPassword.requestFocus();
      }
    }
    simple = !simple;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> pressPhone(PhoneButtonEvent event, Emitter<SignUpState> emit) async {
    selectButton = 0;
    focusEmail.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic);
    focusPhone.requestFocus();
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> pressEmail(EmailButtonEvent event, Emitter<SignUpState> emit) async {
    selectButton = 1;
    focusPhone.unfocus();
    focusFullName.unfocus();
    focusPassword.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(event.width - 60,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic);
    focusEmail.requestFocus();
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> pressCountry(SignUpCountryEvent event, Emitter<SignUpState> emit) async {
    country = false;
    phoneNumberController.text = '';
    countryData = event.countryData;
    phoneInputFormatter = PhoneInputFormatter(defaultCountryCode: event.countryData.countryCode);
    focusPhone.unfocus();
    focusEmail.unfocus();
    focusPassword.unfocus();
    simple = !simple;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
    await Future.delayed(const Duration(milliseconds: 30));
    focusPhone.requestFocus();
  }

  Future<void> pressSignUp(SignUpButtonEvent event, Emitter<SignUpState> emit) async {
    Map<String, dynamic> body = {
      "firstName": 'Example',
      "lastName": null,
      "email": emailController.text,
      "username": fullNameController.text,
      "password": passwordController.text,
      "phoneNumber":
          "+998${phoneNumberController.text.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')}",
      "shortInfo": null,
      "latitude": null,
      "longitude": null,
      "language": null,
      "sendOtp": true,
    };

    String? response = await NetworkService.POST(
        NetworkService.API_SIGN_UP, NetworkService.paramsEmpty(), body);

    if (response != null) {
      Login login = Login.fromJson(jsonDecode(response));
      if (login.success!) {
        print('succes true');
        if (login.result!.mailHasBeenSent!) {
          print('email true');
        } else {
          print('email false');
        }
      } else {
        print(login.error.toString());
      }
    } else {
      print('network error');
    }
  }

  Future<void> pressGoogle(GoogleEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState(
      fullName: fullNameSuffix,
      password: passwordSuffix,
      obscure: obscure,
      email: emailSuffix,
    ));

    UserCredential userCredential = await signInWithGoogle();
    String? email = userCredential.user?.email;
    String? fullName = userCredential.user?.displayName;
    if (email != null) {
      emailController.text = email;
      emailSuffix = true;
      selectButton = 1;
      focusPhone.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      await scrollController.animateTo(event.width - 60,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic);

      if (fullName != null) {
        fullNameController.text = fullName;
        fullNameSuffix = true;
      }
    }

    emit(SignUpEnterState(
        simple: simple,
        phone: phoneSuffix,
        email: true,
        password: passwordSuffix,
        obscure: obscure,
        fullName: fullNameSuffix));
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignUpState> emit) async {
    // todo code
  }

  void pressCountryDropdown(SignUpOnTapCountryButtonEvent event, Emitter<SignUpState> emit) {
    country = true;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));

  }

  void change(SignUpChangeEvent event, Emitter<SignUpState> emit) {
    if (focusPassword.hasFocus) country = false;
    if (phoneNumberController.text.length != countryData.phoneMaskWithoutCountryCode.length) {
      phoneSuffix = false;
    }
    if (!phoneSuffix && phoneNumberController.text.length == countryData.phoneMaskWithoutCountryCode.length) {
      phoneSuffix = true;
    }

    if (fullNameController.text.replaceAll(' ', '').length > 5
        && fullNameController.text.trim().substring(0, fullNameController.text.trim().indexOf(' ')).length > 2
        && fullNameController.text.trim().substring(fullNameController.text.trim().lastIndexOf(' '), fullNameController.text.length).length > 3) {
      fullNameSuffix = true;
    } else {
      fullNameSuffix = false;
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

    if (passwordController.text.length > 5 &&
        (passwordController.text.contains(RegExp('[a-z]')) ||
            passwordController.text.contains(RegExp('[A-Z]'))) &&
        passwordController.text.contains(RegExp('[0-9]')) &&
        !passwordController.text.trim().contains(' ')) {
      passwordSuffix = true;
    } else {
      passwordSuffix = false;
    }
    simple = !simple;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  void pressEye(EyeEvent event, Emitter<SignUpState> emit) {
    obscure = !obscure;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        fullName: fullNameController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,));
  }

  void pressRememberMe(RememberMeEvent event, Emitter<SignUpState> emit) {
    rememberMe = !rememberMe;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        fullName: fullNameController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        obscure: obscure,));
  }

  void pressSignIn(SignInEvent event, Emitter<SignUpState> emit) {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }
}
