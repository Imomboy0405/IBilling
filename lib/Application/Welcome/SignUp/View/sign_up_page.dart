import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return Scaffold(
          backgroundColor: AppColors.black,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // #xonadon
                    const Text('Sign up for free', textAlign: TextAlign.center, style: AppTextStyles.style1),

                    Column(
                      children: [
                        // #text_fields
                        SizedBox(
                          height: 55,
                          child:
                          SingleChildScrollView(
                            controller: bloc.scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Row(children: [
                              // #phone
                              SizedBox(
                                height: 55,
                                width: MediaQuery.of(context).size.width - 60,
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: TextField(
                                    controller: bloc.phoneNumberController,
                                    style: AppTextStyles.style7,
                                    onChanged: (v) => bloc.add(SignUpChangeEvent()),
                                    onTap: () => bloc.add(SignUpChangeEvent()),
                                    onSubmitted: (v) => bloc.add(OnSubmittedEvent()),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [bloc.maskFormatter],
                                    focusNode: bloc.focusPhone,
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 20),
                                      errorText: state is SignUpErrorState
                                          ? 'Invalid phone number'
                                          : null,
                                      prefixIcon: Icon(Icons.phone,
                                          color: state is SignUpEnterState &&
                                              state.phone ||
                                              bloc.focusPhone.hasFocus
                                              ? AppColors.blue
                                              : AppColors.grey),
                                      suffixIcon: bloc.phoneNumberController
                                          .text.isNotEmpty ||
                                          bloc.focusPhone.hasFocus
                                          ? bloc.phoneSuffix
                                          ? const Icon(Icons.done,
                                          color: AppColors.blue)
                                          : const Icon(Icons.error_outline,
                                          color: AppColors.red)
                                          : null,
                                      labelText: 'Phone number',
                                      prefixText: '+998 ',
                                      hintText: '(00) 000-00-00',
                                      hintStyle: AppTextStyles.style6,
                                      prefixStyle: AppTextStyles.style7,
                                      labelStyle: bloc.phoneNumberController
                                          .text.isNotEmpty ||
                                          bloc.focusPhone.hasFocus
                                          ? AppTextStyles.style3
                                          : AppTextStyles.style6,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 2, color: AppColors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: state is SignUpEnterState &&
                                                state.phone
                                                ? AppColors.blue
                                                : AppColors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 2, color: AppColors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // #email
                              SizedBox(
                                height: 55,
                                width: MediaQuery.of(context).size.width - 60,
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: TextField(
                                    controller: bloc.emailController,
                                    style: AppTextStyles.style7,
                                    onChanged: (v) => bloc.add(SignUpChangeEvent()),
                                    onTap: () => bloc.add(SignUpChangeEvent()),
                                    onSubmitted: (v) => bloc.add(OnSubmittedEvent()),
                                    textInputAction: TextInputAction.done,
                                    focusNode: bloc.focusEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      // isCollapsed: true
                                      contentPadding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 20,
                                          right: 0),
                                      suffixIconConstraints:
                                      const BoxConstraints(maxWidth: 35),
                                      errorText: state is SignUpErrorState
                                          ? 'Invalid email'
                                          : null,
                                      prefixIcon: Icon(Icons.mail,
                                          color: state is SignUpEnterState &&
                                              state.email ||
                                              bloc.focusEmail.hasFocus
                                              ? AppColors.blue
                                              : AppColors.grey),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          bloc.emailController.text
                                              .isNotEmpty ||
                                              bloc.focusEmail.hasFocus
                                              ? bloc.emailSuffix
                                              ? const Icon(Icons.done,
                                              color: AppColors.blue)
                                              : const Icon(
                                              Icons.error_outline,
                                              color: AppColors.red)
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                      labelText: 'Email',
                                      hintText: 'aaabbbccc@dddd.eee',
                                      labelStyle: bloc.emailController.text
                                          .isNotEmpty ||
                                          bloc.focusEmail.hasFocus
                                          ? AppTextStyles.style3
                                          : AppTextStyles.style6,
                                      hintStyle: AppTextStyles.style6,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 2, color: AppColors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: state is SignUpEnterState &&
                                                state.email
                                                ? AppColors.blue
                                                : AppColors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 2, color: AppColors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),

                        // #select_buttons
                        Row(
                          children: [
                            SelectButton(context: context, function: () => bloc.add(PhoneButtonEvent()), text: 'Phone', select: bloc.selectButton == 0),
                            const Spacer(),
                            SelectButton(context: context, function: () => bloc.add(EmailButtonEvent(width: MediaQuery.of(context).size.width)), text: 'Email', select: bloc.selectButton == 1),
                          ],
                        ),
                      ],
                    ),

                    // #username
                    SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 60,
                      child: Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: TextField(
                          controller: bloc.usernameController,
                          style: AppTextStyles.style7,
                          onChanged: (v) => bloc.add(SignUpChangeEvent()),
                          onTap: () => bloc.add(SignUpChangeEvent()),
                          onSubmitted: (v) => bloc.add(OnSubmittedEvent(username: true)),
                          textInputAction: TextInputAction.next,
                          focusNode: bloc.focusUsername,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 0,
                                bottom: 0,
                                left: 20,
                                right: 0),
                            suffixIconConstraints:
                            const BoxConstraints(maxWidth: 35),
                            errorText: state is SignUpErrorState
                                ? 'Invalid username'
                                : null,
                            prefixIcon: Icon(Icons.person,
                                color: state is SignUpEnterState &&
                                    state.username ||
                                    bloc.focusUsername.hasFocus
                                    ? AppColors.blue
                                    : AppColors.grey),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                bloc.usernameController.text
                                    .isNotEmpty ||
                                    bloc.focusUsername.hasFocus
                                    ? bloc.usernameSuffix
                                    ? const Icon(Icons.done,
                                    color: AppColors.blue)
                                    : const Icon(
                                    Icons.error_outline,
                                    color: AppColors.red)
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            labelText: 'Username',
                            hintText: 'abcde',
                            labelStyle: bloc.usernameController.text
                                .isNotEmpty ||
                                bloc.focusUsername.hasFocus
                                ? AppTextStyles.style3
                                : AppTextStyles.style6,
                            hintStyle: AppTextStyles.style6,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 2, color: AppColors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: state is SignUpEnterState &&
                                      state.username
                                      ? AppColors.blue
                                      : AppColors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 2, color: AppColors.red),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // #password
                    TextField(
                      controller: bloc.passwordController,
                      style: AppTextStyles.style7,
                      obscureText: bloc.obscure,
                      onChanged: (v) => bloc.add(SignUpChangeEvent()),
                      onTap: () => bloc.add(SignUpChangeEvent()),
                      onSubmitted: (v) => bloc.add(SignUpChangeEvent()),
                      focusNode: bloc.focusPassword,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        prefixIcon: Icon(Icons.lock, color: state is SignUpEnterState && state.password || bloc.focusPassword.hasFocus ? AppColors.blue : AppColors.grey),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            bloc.passwordController.text.trim().isNotEmpty
                                ? IconButton(
                              onPressed: () => bloc.add(EyeEvent()),
                              icon: Icon(
                                bloc.obscure
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: AppColors.blue,
                              ),
                            )
                                : const SizedBox.shrink(),
                            bloc.passwordController.text.isNotEmpty || bloc.focusPassword.hasFocus
                                ? bloc.passwordSuffix
                                ? const Icon(Icons.done, color: AppColors.blue)
                                : const Icon(Icons.error_outline,
                                color: AppColors.red)
                                : const SizedBox.shrink(),
                            const SizedBox(width: 12),
                          ],
                        ),
                        labelText: 'Password',
                        hintText: '123abc',
                        labelStyle: bloc.passwordController.text.isNotEmpty || bloc.focusPassword.hasFocus ? AppTextStyles.style3 : AppTextStyles.style6,
                        hintStyle: AppTextStyles.style6,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 2, color: state is SignUpEnterState && state.password ? AppColors.blue : AppColors.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.red),
                        ),
                      ),
                    ),

                    // #buttons
                    Column(
                      children: [
                        // #remember_me
                        Row(
                          children: [
                            Checkbox(
                              onChanged: (v) => context
                                  .read<SignUpBloc>()
                                  .add(RememberMeEvent()),
                              value: bloc.rememberMe,
                              shape: const StadiumBorder(
                                  side: BorderSide(color: AppColors.blue)),
                            ),
                            TextButton(
                                onPressed: () => context
                                    .read<SignUpBloc>()
                                    .add(RememberMeEvent()),
                                child: const Text('Remember me',
                                    style: AppTextStyles.style9)),
                          ],
                        ),

                        // #sing_in
                        (bloc.emailSuffix || bloc.phoneSuffix) &&
                                bloc.passwordSuffix &&
                                bloc.usernameSuffix
                            ? MaterialButton(
                                onPressed: () => context
                                    .read<SignUpBloc>()
                                    .add(SignUpButtonEvent()),
                                color: AppColors.blue,
                                minWidth: double.infinity,
                                height: 50,
                                shape: const StadiumBorder(),
                                child: const Text(
                                  'Sign up',
                                  style: AppTextStyles.style4,
                                ),
                              )
                            : Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.disableBlue,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Text(
                                  'Sign up',
                                  style: AppTextStyles.style4,
                                ),
                              ),
                      ],
                    ),

                    // #or_continue_width
                    const Text('or continue width', textAlign: TextAlign.center, style: AppTextStyles.style2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // #facebook
                        TextButton(
                          onPressed: () => context.read<SignUpBloc>().add(FaceBookEvent()),
                          child: const Row(
                            children: [
                              SizedBox(height: 25, child: Image(image: AssetImage('assets/icons/ic_facebook.png'))),
                              Text(' Facebook', style: AppTextStyles.style9),
                            ],
                          ),
                        ),

                        // #google
                        TextButton(
                          onPressed: () => context.read<SignUpBloc>().add(GoogleEvent(width: MediaQuery.of(context).size.width)),
                          child: const Row(
                            children: [
                              SizedBox(height: 25, child: Image(image: AssetImage('assets/icons/ic_google.png'))),
                              Text(' Google', style: AppTextStyles.style9),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // #sing_up
                    RichText(
                      text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account?  ',
                              style: AppTextStyles.style2,
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: AppTextStyles.style9,
                              recognizer: TapGestureRecognizer()..onTap = () => bloc.add(SignInEvent(context: context)),
                            ),
                          ]
                      ),
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