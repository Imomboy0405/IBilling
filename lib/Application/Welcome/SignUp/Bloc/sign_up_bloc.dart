import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../Data/Model/login_model.dart';
import '../../../../Data/Service/google_sign_in_service.dart';
import '../../../../Data/Service/lang_service.dart';
import '../../../../Data/Service/network_service.dart';
import '../../SignIn/View/sign_in_page.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  bool rememberMe = false;
  bool obscure = true;
  bool phoneSuffix = false;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  bool usernameSuffix = false;
  bool simple = false;
  FocusNode focusPhone = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusUsername = FocusNode();
  int selectButton = 0;
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) ###-##-##',
    filter: {"#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.eager,
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  ScrollController scrollController = ScrollController();

  SignUpBloc() : super(SignUpEnterState(simple: false, phone: false, obscure: false, rememberMe: true, email: false, password: false, username: false)) {
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
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignUpState> emit) async {
    if(!event.username) {
      focusPhone.unfocus();
      focusEmail.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusUsername.requestFocus();
    }
    simple = !simple;
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim()
            .isNotEmpty, password: passwordController.text
            .trim().isNotEmpty, obscure: obscure, rememberMe: rememberMe,
        username: usernameController.text.trim().isNotEmpty));
  }

  Future<void> pressPhone(PhoneButtonEvent event, Emitter<SignUpState> emit) async {
    selectButton = 0;
    focusEmail.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
    focusPhone.requestFocus();
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim()
            .isNotEmpty, password: passwordController.text
            .trim().isNotEmpty, obscure: obscure, rememberMe: rememberMe,
        username: usernameController.text.trim().isNotEmpty));
  }

  Future<void> pressEmail(EmailButtonEvent event, Emitter<SignUpState> emit) async {
    selectButton = 1;
    focusPhone.unfocus();
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(event.width - 60, duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
    focusEmail.requestFocus();
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim()
            .isNotEmpty, password: passwordController.text
            .trim().isNotEmpty, obscure: obscure, rememberMe: rememberMe,
        username: usernameController.text.trim().isNotEmpty));
  }

  Future<void> pressSignUp(SignUpButtonEvent event, Emitter<SignUpState> emit) async {
    Map<String, dynamic> body = {
      "firstName": 'Example',
      "lastName": null,
      "email": emailController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "phoneNumber": "+998${phoneNumberController.text.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')}",
      "shortInfo": null,
      "latitude": null,
      "longitude": null,
      "language": null,
      "sendOtp": true,
    };

    String? response = await NetworkService.POST(NetworkService.API_SIGN_UP, NetworkService.paramsEmpty(), body);

    if(response != null) {
      Login login = Login.fromJson(jsonDecode(response));
      if(login.success!) {
        print('succes true');
        if(login.result!.mailHasBeenSent!) {
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
    final email = await signInWithGoogle();
    if(email != null) {
      emailController.text = email;
      emailSuffix = true;
      selectButton = 1;
      focusPhone.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      await scrollController.animateTo(event.width - 60, duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
      emit(SignUpEnterState(simple: simple, phone: phoneSuffix, email: true, password: passwordSuffix, obscure: obscure, rememberMe: rememberMe, username: usernameSuffix));
    }
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignUpState> emit) async {
    // todo code
  }

  void change(SignUpChangeEvent event, Emitter<SignUpState> emit) {
    if (usernameController.text.trim().length > 4) {
      usernameSuffix = true;
    } else {
      usernameSuffix = false;
    }
    if (phoneNumberController.text.length != 14) {
      phoneSuffix = false;
    }
    if (!phoneSuffix && phoneNumberController.text.length == 14) {
      phoneSuffix = true;
    }

    if (emailController.text.contains('@') && emailController.text.contains('.')
        && emailController.text.substring(0, emailController.text.indexOf('@')).isNotEmpty
        && emailController.text.substring(emailController.text.indexOf('@') + 1, emailController.text.indexOf('.')).isNotEmpty
        && emailController.text.substring(emailController.text.indexOf('.') + 1, emailController.text.length).isNotEmpty) {
      emailSuffix = true;
    } else {
      emailSuffix = false;
    }

    if (passwordController.text.length > 5
        && (passwordController.text.contains(RegExp('[a-z]')) || passwordController.text.contains(RegExp('[A-Z]')))
        && passwordController.text.contains(RegExp('[0-9]')) && !passwordController.text.trim().contains(' ')) {
      passwordSuffix = true;
    } else {
      passwordSuffix = false;
    }
    simple = !simple;
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim()
            .isNotEmpty, password: passwordController.text
            .trim().isNotEmpty, obscure: obscure, rememberMe: rememberMe,
        username: usernameController.text.trim().isNotEmpty));
  }

  void pressEye(EyeEvent event, Emitter<SignUpState> emit) {
    obscure = !obscure;
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        username: usernameController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty, password: passwordController.text.trim().isNotEmpty,
        obscure: obscure, rememberMe: rememberMe));
  }

  void pressRememberMe(RememberMeEvent event, Emitter<SignUpState> emit) {
    rememberMe = !rememberMe;
    emit(SignUpEnterState(simple: simple, phone: phoneNumberController.text.trim().isNotEmpty,
        username: usernameController.text.trim().isNotEmpty, email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty, obscure: obscure, rememberMe: rememberMe));
  }

  void pressSignIn(SignInEvent event, Emitter<SignUpState> emit) {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }
}

