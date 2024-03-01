import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/logic_service.dart';
import 'package:i_billing/Data/Service/rtdb_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

import '../../../../Data/Service/auth_service.dart';
import '../../../../Data/Service/lang_service.dart';
import '../../SignIn/View/sign_in_page.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  Language selectedLang = LangService.getLanguage;
  bool googleOrFacebook = false;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool obscureRePassword = true;
  bool phoneSuffix = false;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  bool rePasswordSuffix = false;
  bool fullNameSuffix = false;
  bool smsSuffix = false;
  bool simple = false;
  bool country = false;
  bool sms = false;
  bool email = false;
  FocusNode focusPhone = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusRePassword = FocusNode();
  FocusNode focusFullName = FocusNode();
  FocusNode focusSms = FocusNode();
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
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  ScrollController scrollController = ScrollController();

  SignUpBloc()
      : super(SignUpEnterState(
            simple: false,
            phone: false,
            obscurePassword: true,
            obscureRePassword: true,
            email: false,
            password: false,
            rePassword: false,
            fullName: false,
  )) {
    on<SignUpChangeEvent>(change);
    on<OnSubmittedEvent>(onSubmitted);
    on<PasswordEyeEvent>(pressPasswordEye);
    on<RePasswordEyeEvent>(pressRePasswordEye);
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
    on<SignUpConfirmEvent>(pressConfirm);
    on<SignUpCancelEvent>(pressCancel);
  }

  Future<void> pressCancel(SignUpCancelEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    if (selectButton == 1) {
      await FirebaseAuth.instance.currentUser!.delete();
      email = false;
    }
    sms = false;

    emit(SignUpEnterState(
        simple: simple,
        phone: true,
        email: true,
        password: true,
        rePassword: true,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
        fullName: true,
    ));
  }

  Future<void> pressConfirm(SignUpConfirmEvent event, Emitter<SignUpState> emit) async {
    bool verifyDone = false;
    emit(SignUpLoadingState());

    if (selectButton == 0) {
      try {
        verifyDone = await AuthService.verifyOTP(smsCodeController.text.trim());
      } catch (e) {
        /// todo
      }
      if (verifyDone) {
        UserModel userModel = UserModel(
          fullName: fullNameController.text.trim(),
          password: passwordController.text.trim(),
          email: null,
          phoneNumber: phoneNumberController.text.trim(),
          uId: FirebaseAuth.instance.currentUser!.uid,
          createdTime: DateTime.now().toString().substring(0,10),
        );
        try {
          await RTDBService.storeUser(userModel);
          if (event.context.mounted) {
            Utils.mySnackBar(txt: 'account_created'.tr(), context: event.context);
            Navigator.pushReplacementNamed(event.context, SignInPage.id);
          }
        } catch (e) {
          if (event.context.mounted) {
            Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
          }
        }
      } else {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'invalid_sms'.tr(), context: event.context, errorState: true);
        }
        emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
      }
    } else {
      verifyDone = await AuthService.verifyEmailLink();
      if (verifyDone) {
        UserModel userModel = UserModel(
          fullName: fullNameController.text.trim(),
          password: passwordController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: null,
          uId: FirebaseAuth.instance.currentUser!.uid,
          createdTime: DateTime.now().toString().substring(0,10),
        );
        try {
          await RTDBService.storeUser(userModel);
          if (event.context.mounted) {
            Utils.mySnackBar(txt: 'account_created'.tr(), context: event.context);
            Navigator.pushReplacementNamed(event.context, SignInPage.id);
          }
        } catch (e) {
          if (event.context.mounted) {
            Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
          }
        }
      } else {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'email_not_verified'.tr(), context: event.context, errorState: true);
        }
        emit(SignUpVerifyPhoneState());
      }
    }
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter<SignUpState> emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(SignUpFlagState());
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignUpState> emit) async {
    if(fullNameController.text.isNotEmpty) {
      fullNameController.text = fullNameController.text.replaceAll(RegExp(r'\s+'), ' ');
    }
    if (event.password) {
      focusPassword.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusRePassword.requestFocus();
    } else {
      if (event.fullName) {
        focusFullName.unfocus();
        await Future.delayed(const Duration(milliseconds: 30));
        focusPassword.requestFocus();
      } else {
        if(event.rePassword) {
          focusRePassword.unfocus();
          } else {
          focusEmail.unfocus();
          focusPhone.unfocus();
          country = false;
          await Future.delayed(const Duration(milliseconds: 30));
          focusFullName.requestFocus();
        }
      }
    }
    simple = !simple;
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
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
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
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
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  Future<void> pressCountry(SignUpCountryEvent event, Emitter<SignUpState> emit) async {
    country = false;
    phoneSuffix = false;
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
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
        fullName: fullNameController.text.trim().isNotEmpty));
    await Future.delayed(const Duration(milliseconds: 30));
    focusPhone.requestFocus();
  }

  Future<void> pressSignUp(SignUpButtonEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState( ));

    if (googleOrFacebook) {
      UserModel userModel = UserModel(
        fullName: fullNameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        uId: FirebaseAuth.instance.currentUser!.uid,
        createdTime: DateTime.now().toString().substring(0,10),
      );

      try {
        await RTDBService.storeUser(userModel);
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'account_created'.tr(), context: event.context);
          Navigator.pushReplacementNamed(event.context, SignInPage.id);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
        emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
      }

    } else {
      await FirebaseAuth.instance.setLanguageCode(selectedLang.name);

      if (selectButton == 1) {
        try {
          await AuthService.createUser(emailController.text.trim(), passwordController.text.trim());
          await AuthService.verifyEmail(emailController.text.trim());
          emit(SignUpVerifyPhoneState());
          email = true;
        } catch (e) {
          if (LogicService.parseError(e.toString()) == 'email-already-in-use') {
            if (event.context.mounted) {
              Utils.mySnackBar(txt: 'email_already_in_use'.tr(), context: event.context, errorState: true);
            }
          } else {
            if (event.context.mounted) {
              Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
            }
          }
          emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
        }
      } else {
        try {
          String response = await AuthService.verifyPhoneNumber(
              '+${countryData.phoneCode! +
                  RegExp(r'\d+').allMatches(phoneNumberController.text).map((s) => s.group(0)).join('')}');

          if (response == 'send') {
            sms = true;
            emit(SignUpEnterState(
              simple: simple,
              phone: true,
              email: true,
              password: true,
              rePassword: true,
              obscurePassword: obscurePassword,
              obscureRePassword: obscureRePassword,
              fullName: true,
            ));
          } else {
            if (event.context.mounted) {
              Utils.mySnackBar(txt: response, context: event.context, errorState: true);
            }
            emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
          }
        } catch (e) {
          if (event.context.mounted) {
            Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
          }
          emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));

        }
      }

    }
  }

  Future<void> pressGoogle(GoogleEvent event, Emitter<SignUpState> emit) async {
    if (googleOrFacebook) {
      Utils.mySnackBar(txt: 'completed_google'.tr(), context: event.context);
    } else {
      emit(SignUpLoadingState());

      try {
        UserCredential userCredential = await AuthService.signInWithGoogle();
        if (event.context.mounted) {
          await checkAuthCredential(userCredential: userCredential, context: event.context, width: event.width);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
      }

      emit(SignUpEnterState(
          simple: simple,
          phone: phoneSuffix,
          email: true,
          password: passwordSuffix,
          rePassword: rePasswordSuffix,
          obscurePassword: obscurePassword,
          obscureRePassword: obscureRePassword,
          fullName: fullNameSuffix));
    }
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignUpState> emit) async {
    if (googleOrFacebook) {
      Utils.mySnackBar(txt: 'completed_facebook'.tr(), context: event.context);
    } else {
      emit(SignUpLoadingState());

      try {
        UserCredential userCredential = await AuthService.signInWithFacebook();
        if (event.context.mounted) {
          await checkAuthCredential(userCredential: userCredential, context: event.context, width: event.width);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
      }
      emit(SignUpEnterState(
          simple: simple,
          phone: phoneSuffix,
          email: true,
          password: passwordSuffix,
          rePassword: rePasswordSuffix,
          obscurePassword: obscurePassword,
          obscureRePassword: obscureRePassword,
          fullName: fullNameSuffix));
    }
  }

  void pressCountryDropdown(SignUpOnTapCountryButtonEvent event, Emitter<SignUpState> emit) {
    country = true;
  }

  void change(SignUpChangeEvent event, Emitter<SignUpState> emit) {
    if (focusPassword.hasFocus) country = false;

    phoneSuffix = phoneNumberController.text.length == countryData.phoneMaskWithoutCountryCode.length;
    fullNameSuffix = LogicService.checkFullName(fullNameController.text);
    emailSuffix = LogicService.checkEmail(emailController.text);
    passwordSuffix = LogicService.checkPassword(passwordController.text);
    rePasswordSuffix = passwordController.text == rePasswordController.text;
    smsSuffix = smsCodeController.text.trim().length == 6;
    simple = !simple;

    if (emailController.text.isNotEmpty) {
      emailController.text = emailController.text.replaceAll(' ', '');
    }
    emit(SignUpEnterState(
        simple: simple,
        phone: phoneNumberController.text.trim().isNotEmpty,
        email: emailController.text.trim().isNotEmpty,
        password: passwordController.text.trim().isNotEmpty,
        rePassword: passwordController.text == rePasswordController.text,
        obscurePassword: obscurePassword,
        obscureRePassword: obscureRePassword,
        fullName: fullNameController.text.trim().isNotEmpty));
  }

  void pressPasswordEye(PasswordEyeEvent event, Emitter<SignUpState> emit) {
    obscurePassword = !obscurePassword;
    emit(SignUpEnterState(
      simple: simple,
      phone: phoneNumberController.text.trim().isNotEmpty,
      fullName: fullNameController.text.trim().isNotEmpty,
      email: emailController.text.trim().isNotEmpty,
      password: passwordController.text.trim().isNotEmpty,
      rePassword: passwordController.text == rePasswordController.text,
      obscurePassword: obscurePassword,
      obscureRePassword: obscureRePassword,
    ));
  }

  void pressRePasswordEye(RePasswordEyeEvent event, Emitter<SignUpState> emit) {
    obscureRePassword = !obscureRePassword;
    emit(SignUpEnterState(
      simple: simple,
      phone: phoneNumberController.text.trim().isNotEmpty,
      fullName: fullNameController.text.trim().isNotEmpty,
      email: emailController.text.trim().isNotEmpty,
      password: passwordController.text.trim().isNotEmpty,
      rePassword: passwordController.text == rePasswordController.text,
      obscurePassword: obscurePassword,
      obscureRePassword: obscureRePassword,
    ));
  }

  void pressRememberMe(RememberMeEvent event, Emitter<SignUpState> emit) {
    rememberMe = !rememberMe;
    emit(SignUpEnterState(
      simple: simple,
      phone: phoneNumberController.text.trim().isNotEmpty,
      fullName: fullNameController.text.trim().isNotEmpty,
      email: emailController.text.trim().isNotEmpty,
      password: passwordController.text.trim().isNotEmpty,
      rePassword: passwordController.text == rePasswordController.text,
      obscurePassword: obscurePassword,
      obscureRePassword: obscureRePassword,
    ));
  }

  void pressSignIn(SignInEvent event, Emitter<SignUpState> emit) async {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }

  Future<void> checkAuthCredential({required UserCredential userCredential, required BuildContext context, required double width}) async {
    String? uId = userCredential.user?.uid;
    String? email = userCredential.user?.email;
    String? fullName = userCredential.user?.displayName;

    if (uId != null) {
      googleOrFacebook = true;
      if(email != null) {
        emailController.text = email;
      } else {
        emailController.text = '';
      }
      emailSuffix = true;
      selectButton = 1;
      focusPhone.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      await scrollController.animateTo(width - 60,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic);
      if (fullName != null) {
        fullNameController.text = fullName;
        fullNameSuffix = true;
        if (!passwordSuffix && context.mounted) {
          Utils.mySnackBar(txt: 'enter_password'.tr(), context: context, errorState: true);
          focusPassword.requestFocus();
        } else if (!rePasswordSuffix && context.mounted) {
          Utils.mySnackBar(txt: 'enter_re_password'.tr(), context: context, errorState: true);
          focusRePassword.requestFocus();
        }
      } else {
        if (!fullNameSuffix && context.mounted) {
          Utils.mySnackBar(txt: 'enter_fullName'.tr(), context: context, errorState: true);
        }
        focusFullName.requestFocus();
      }

    } else {
      if (context.mounted) {
        Utils.mySnackBar(txt: 'error_cloud_data'.tr(), context: context, errorState: true);
      }
    }
  }
}
