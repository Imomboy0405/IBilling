import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';

import '../../../Configuration/app_colors.dart';
import '../../Menus/Contracts/View/contracts_page.dart';
import '../../Menus/History/View/history_page.dart';
import '../../Menus/New/View/new_page.dart';
import '../../Menus/Profile/View/profile_page.dart';
import '../../Menus/Saved/View/saved_page.dart';
import '../Bloc/main_bloc.dart';

class MainPage extends StatelessWidget {
  static const id = '/main_page';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          MainBloc bloc = context.read<MainBloc>();
          bloc.controller.addListener(() => bloc.listen());
          return Scaffold(
            backgroundColor: AppColors.black,
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 200,
                      height: 83,
                      color: AppColors.dark,
                    ),
                    MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),

                    PageView(
                      physics: state is MainInitialState
                                 ? const BouncingScrollPhysics()
                                 : const NeverScrollableScrollPhysics(),
                      controller: bloc.controller,
                      pageSnapping: true,
                      children: const [
                        ProfilePage(),
                        ContractsPage(key: Key('1')),
                        HistoryPage(),
                        NewPage(),
                        SavedPage(),
                        ProfilePage(),
                        ContractsPage(key: Key('2')),
                      ],
                    ),

                    if(state is! MainHideBottomNavigationBarState)
                      MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),

                  ],
                ),
              ),
            ),

          );
        },
      ),
    );
  }
}
