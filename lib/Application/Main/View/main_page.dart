import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Configuration/app_colors.dart';
import '../../Menus/Contracts/View/contracts_page.dart';
import '../../Menus/History/View/history_page.dart';
import '../../Menus/New/View/new_page.dart';
import '../../Menus/Profile/View/profile_page.dart';
import '../../Menus/Saved/View/saved_page.dart';
import '../Bloc/main_bloc.dart';

@immutable
class MainPage extends StatelessWidget {
  MainBloc bloc = MainBloc();

  MainPage({super.key});

  void listen() async {
    if (bloc.controller.page! <= 0.001) {
      bloc.controller.jumpToPage(4);
    } else if (bloc.controller.page! >= 4.999) {
      bloc.controller.jumpToPage(1);
    }

    if (bloc.controller.page! - bloc.controller.page!.truncate() < 1){
      bloc.currentScreen = bloc.controller.page!.round();
    }

    if (bloc.currentScreen != bloc.oldScreen) {
      bloc.oldScreen = bloc.currentScreen;
      bloc.add(MainMenuEvent(index: bloc.currentScreen));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          bloc = context.read<MainBloc>();
          bloc.controller.addListener(() => listen());
          return Scaffold(
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  controller: bloc.controller,
                  children: const [
                    ProfilePage(),
                    ContractsPage(),
                    HistoryPage(),
                    NewPage(),
                    SavedPage(),
                    ProfilePage(),
                    ContractsPage(),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  height: screenWidth * .155,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => bloc.add(MainChangeEvent(index: index)),
                      splashColor: AppColors.transparentBlue,
                      highlightColor: AppColors.transparentBlue,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: screenWidth * .2125,
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                height:
                                index+1 == bloc.currentScreen ? screenWidth * .12 : 0,
                                width:
                                index+1 == bloc.currentScreen ? screenWidth * .2125 : 0,
                                decoration: BoxDecoration(
                                  color: index+1 == bloc.currentScreen
                                      ? Colors.blueAccent.withOpacity(.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * .2125,
                            alignment: Alignment.center,
                            child: Icon(
                              bloc.listOfIcons[index],
                              size: screenWidth * .076,
                              color: index+1 == bloc.currentScreen
                                  ? Colors.blueAccent
                                  : Colors.black26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        },
      ),
    );
  }
}
