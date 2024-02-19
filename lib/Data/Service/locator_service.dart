import 'package:get_it/get_it.dart';
import 'package:i_billing/Application/Menus/Profile/Bloc/profile_bloc.dart';
import 'package:i_billing/Application/Welcome/SignUp/Bloc/sign_up_bloc.dart';

import '../../Application/Welcome/Start/Bloc/start_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<ProfileBloc>(ProfileBloc());

}