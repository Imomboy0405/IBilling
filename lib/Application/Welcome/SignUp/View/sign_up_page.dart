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
                title: const Text('IBilling', style: AppTextStyles.style0_1),
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
                            Text('sign_up_for_free'.tr(), textAlign: TextAlign.center, style: AppTextStyles.style1),

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
                              enable: (bloc.emailSuffix || bloc.phoneSuffix) && bloc.fullNameSuffix
                                  && bloc.passwordSuffix && bloc.rePasswordSuffix,
                              function: () => context.read<SignUpBloc>().add(SignUpButtonEvent(context: context)),
                            ),

                            // #or_continue_with
                            Text(
                              'or_continue_with'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.style2,
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
                                Text('or'.tr(), style: AppTextStyles.style2),

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
                                  style: AppTextStyles.style2,
                                ),
                                TextSpan(
                                  text: 'log_in'.tr(),
                                  style: AppTextStyles.style9,
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
                                    textAlign: TextAlign.center, style: AppTextStyles.style1),
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

// final kFirebaseAnalytics = FirebaseAnalytics.instance;
//
// // NOTE: to add firebase support, first go to firebase console, generate the
// // firebase json file, and add configuration lines in the gradle files.
// // C.f. this commit: https://github.com/X-Wei/flutter_catalog/commit/48792cbc0de62fc47e0e9ba2cd3718117f4d73d1.
// class FirebaseLoginExample extends StatefulWidget {
//   const FirebaseLoginExample({Key? key}) : super(key: key);
//
//   @override
//   _FirebaseLoginExampleState createState() => _FirebaseLoginExampleState();
// }
//
// class _FirebaseLoginExampleState extends State<FirebaseLoginExample> {
//   final _auth = firebase_auth.FirebaseAuth.instance;
//   firebase_auth.User? _user;
//   // If this._busy=true, the buttons are not clickable. This is to avoid
//   // clicking buttons while a previous onTap function is not finished.
//   bool _busy = false;
//
//   @override
//   void initState() {
//     super.initState();
//     this._user = _auth.currentUser;
//     _auth.authStateChanges().listen((firebase_auth.User? usr) {
//       this._user = usr;
//       debugPrint('user=$_user');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final statusText = Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Text(
//         _user == null
//             ? 'You are not logged in.'
//             : 'You are logged in as "${_user!.displayName}".',
//       ),
//     );
//     final googleLoginBtn = MaterialButton(
//       color: Colors.blueAccent,
//       onPressed: this._busy
//           ? null
//           : () async {
//         setState(() => this._busy = true);
//         final user = await this._googleSignIn();
//         this._showUserProfilePage(user!);
//         setState(() => this._busy = false);
//       },
//       child: const Text('Log in with Google'),
//     );
//     final anonymousLoginBtn = MaterialButton(
//       color: Colors.deepOrange,
//       onPressed: this._busy
//           ? null
//           : () async {
//         setState(() => this._busy = true);
//         final user = await this._anonymousSignIn();
//         this._showUserProfilePage(user!);
//         setState(() => this._busy = false);
//       },
//       child: const Text('Log in anonymously'),
//     );
//     final signOutBtn = TextButton(
//       onPressed: this._busy
//           ? null
//           : () async {
//         setState(() => this._busy = true);
//         await this._signOut();
//         setState(() => this._busy = false);
//       },
//       child: const Text('Log out'),
//     );
//     return Center(
//       child: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
//         children: <Widget>[
//           statusText,
//           googleLoginBtn,
//           anonymousLoginBtn,
//           signOutBtn,
//         ],
//       ),
//     );
//   }
//
//   // Sign in with Google.
//   Future<firebase_auth.User?> _googleSignIn() async {
//     final curUser = this._user ?? _auth.currentUser;
//     if (curUser != null && !curUser.isAnonymous) {
//       return curUser;
//     }
//     final googleUser = await GoogleSignIn().signIn();
//     final googleAuth = await googleUser!.authentication;
//     final credential = firebase_auth.GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
//     final user = (await _auth.signInWithCredential(credential)).user;
//     kFirebaseAnalytics.logLogin();
//     setState(() => this._user = user);
//     return user;
//   }
//
//   // Sign in Anonymously.
//   Future<firebase_auth.User?> _anonymousSignIn() async {
//     final curUser = this._user ?? _auth.currentUser;
//     if (curUser != null && curUser.isAnonymous) {
//     return curUser;
//     }
//     final anonyUser = (await _auth.signInAnonymously()).user;
//     await anonyUser!
//         .updateDisplayName('${anonyUser.uid.substring(0, 5)}_Guest');
//     await anonyUser.reload();
//     // Have to re-call currentUser() to make updateProfile work.
//     // Cf. https://stackoverflow.com/questions/50986191/flutter-firebase-auth-updateprofile-method-is-not-working.
//     final user = _auth.currentUser;
//     kFirebaseAnalytics.logLogin();
//     setState(() => this._user = user);
//     return user;
//   }
//
//   Future<void> _signOut() async {
//     final user = _auth.currentUser;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           user == null
//               ? 'No user logged in.'
//               : '"${user.displayName}" logged out.',
//         ),
//       ),
//     );
//     _auth.signOut();
//     setState(() => this._user = null);
//   }
//
//   // Show user's profile in a new screen.
//   void _showUserProfilePage(firebase_auth.User user) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => Scaffold(
//           appBar: AppBar(
//             title: const Text('user profile'),
//           ),
//           body: ListView(
//             children: <Widget>[
//               ListTile(title: Text('User: $user')),
//               ListTile(title: Text('User id: ${user.uid}')),
//               ListTile(title: Text('Display name: ${user.displayName}')),
//               ListTile(title: Text('Anonymous: ${user.isAnonymous}')),
//               ListTile(title: Text('Email: ${user.email}')),
//               ListTile(
//                 title: const Text('Profile photo: '),
//                 trailing: user.photoURL != null
//                     ? CircleAvatar(
//                   backgroundImage: NetworkImage(user.photoURL!),
//                 )
//                     : CircleAvatar(
//                   child: Text(user.displayName![0]),
//                 ),
//               ),
//               ListTile(
//                 title: Text('Last sign in: ${user.metadata.lastSignInTime}'),
//               ),
//               ListTile(
//                 title: Text('Creation time: ${user.metadata.creationTime}'),
//               ),
//               ListTile(title: Text('ProviderData: ${user.providerData}')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
