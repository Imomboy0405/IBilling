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
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 200,
                  height: 83,
                  color: AppColors.dark,
                ),
                MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),

                PageView(
                  controller: bloc.controller,
                  pageSnapping: true,
                  children: [
                    ProfilePage(mainBloc: bloc),
                    const ContractsPage(),
                    const HistoryPage(),
                    const NewPage(),
                    const SavedPage(),
                    ProfilePage(mainBloc: bloc),
                    const ContractsPage(),
                  ],
                ),

                if(state is! MainHideBottomNavigationBarState)
                  MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),
              ],
            ),

          );
        },
      ),
    );
  }
}
