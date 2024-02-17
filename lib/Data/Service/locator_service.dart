import 'package:get_it/get_it.dart';

import '../../Application/Welcome/Start/Bloc/start_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerFactory(() => StartBloc());
  locator.registerFactory(() {
    var startBloc = locator();
    return startBloc;
  });
}