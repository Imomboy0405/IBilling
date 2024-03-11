import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Service/db_service.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';
import 'package:shimmer/shimmer.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final FilterSearchButtons? filterSearchButtons;

  const MyAppBar({
    super.key,
    required this.titleText,
    this.filterSearchButtons,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: filterSearchButtons != null ? AppColors.black : AppColors.darker,
      surfaceTintColor: AppColors.black,
      shadowColor: AppColors.gray,
      titleSpacing: 10,
      title: Row(
        children: [
          // #color_image
          const SizedBox(width: 10),
          const Image(
            image: AssetImage('assets/icons/ic_color.png'),
            width: 24,
            height: 24,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 12),

          // #title
          Text(titleText, style: AppTextStyles.style18(context)),

          if (filterSearchButtons != null)
            Flexible(
              child: Row(
                children: [
                  // #filter
                  const Spacer(),
                  IconButton(
                      onPressed: () => filterSearchButtons!.functionFilter(),
                      highlightColor: AppColors.transparentWhite,
                      icon: Image(image: const AssetImage('assets/icons/ic_filter.png'), width: 22, height: 22, color: AppColors.white)),

                  // #divider_vertical
                  SizedBox(width: 10, height: 20, child: Divider(thickness: 20, color: AppColors.white, indent: 4, endIndent: 4)),

                  // #search
                  IconButton(
                      onPressed: () => filterSearchButtons!.functionSearch(),
                      highlightColor: AppColors.transparentWhite,
                      icon: Icon(CupertinoIcons.search, color: AppColors.white)),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 57);
}

enum MySearch { saved, contracts, history }

class MySearchDelegate extends SearchDelegate {
  final MainBloc mainBloc;
  final MySearch mySearch;
  final void Function({required int index}) pressSearchElement;

  MySearchDelegate({required this.mainBloc, required this.pressSearchElement, this.mySearch = MySearch.contracts}) : super();

  @override
  Widget buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: IconButton(
        tooltip: 'back'.tr(),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          color: Colors.white,
          size: 24,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    switch (mySearch) {
      case MySearch.saved:
        {
          mainBloc.suggestions = query.isEmpty
              ? mainBloc.historyListSavedContracts
              : mainBloc.savedContracts.where((word) =>
                  !word.fullName!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.address!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.number!.toString().split(' ').indexWhere((e) => e.startsWith(query)).isNegative);
          break;
        }
      case MySearch.history:
        {
          mainBloc.suggestions = query.isEmpty
              ? mainBloc.historyListHistoryContracts
              : mainBloc.historyContracts.where((word) =>
                  !word.fullName!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.address!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.number!.toString().split(' ').indexWhere((e) => e.startsWith(query)).isNegative);
          break;
        }
      default:
        {
          mainBloc.suggestions = query.isEmpty
              ? mainBloc.historyListContracts
              : mainBloc.contracts.where((word) =>
                  !word.fullName!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.address!.toLowerCase().split(' ').indexWhere((e) => e.startsWith(query.toLowerCase())).isNegative ||
                  !word.number!.toString().split(' ').indexWhere((e) => e.startsWith(query)).isNegative);
        }
    }
    return SuggestionList(
      query: query,
      mainBloc: mainBloc,
      mySearch: mySearch,
      presSearchElement: ({required int index}) => pressSearchElement(index: index),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            tooltip: 'Voice Search',
            icon: const Icon(CupertinoIcons.mic_solid, size: 24, color: Colors.white),
            onPressed: () {
              query = 'TODO: implement voice input';
            },
          ),
        )
      else
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.clear, size: 24, color: Colors.white),
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
          ),
        )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.blackBlue,
        titleSpacing: 10,
      ),
      scaffoldBackgroundColor: AppColors.black,
      textTheme: TextTheme(
        titleMedium: AppTextStyles.style20_2(context),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.style20_1(context),
        labelStyle: AppTextStyles.style20_2(context),
        border: InputBorder.none,
      ),
    );
  }
}

class SuggestionList extends StatelessWidget {
  final MainBloc mainBloc;
  final MySearch mySearch;
  final Function({required int index}) presSearchElement;

  const SuggestionList({super.key, required this.presSearchElement, required this.query, required this.mainBloc, required this.mySearch});

  final String query;

  @override
  Widget build(BuildContext context) {
    return mainBloc.suggestions.isNotEmpty
        ? Column(
            children: [
              query.isEmpty
                  ? Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, color: AppColors.lightGrey, size: 20),
                            Text(
                              ' Your history',
                              style: AppTextStyles.style25_2(context),
                            ),
                          ],
                        ),
                        MaterialButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  ctx: context,
                                  text: 'Are you sure you want to clear your search history?',
                                  okFunction: () async {
                                    switch (mySearch) {
                                      case MySearch.saved:
                                        {
                                          mainBloc.historyListSavedContracts.clear();
                                          mainBloc.suggestions = [];
                                          mainBloc.historyModel.savedHistory = [];
                                          Navigator.pop(context);
                                          await DBService.saveHistory(mainBloc.historyModel);
                                          break;
                                        }
                                      case MySearch.history:
                                        {
                                          mainBloc.historyListHistoryContracts.clear();
                                          mainBloc.suggestions = [];
                                          mainBloc.historyModel.historyHistory = [];
                                          Navigator.pop(context);
                                          await DBService.saveHistory(mainBloc.historyModel);
                                          break;
                                        }
                                      default:
                                        {
                                          mainBloc.historyListContracts.clear();
                                          mainBloc.suggestions = [];
                                          mainBloc.historyModel.history = [];
                                          Navigator.pop(context);
                                          await DBService.saveHistory(mainBloc.historyModel);
                                        }
                                    }
                                  },
                                );
                              }),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                  itemCount: mainBloc.suggestions.length,
                  itemBuilder: (BuildContext context, int i) {
                    final ContractModel suggestion = mainBloc.suggestions.toList()[i];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width - (query.isEmpty ? 63 : 0),
                      child: MyInvoiceOrContractContainer(
                        contract: true,
                        contractModel: suggestion,
                        last: mainBloc.contracts.length,
                        onPressed: (context) => presSearchElement(index: i),
                        index: i,
                        animatedDisabled: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : MyNotFoundWidget(text: 'contract_not_found'.tr());
  }
}

class AnimatedTxt extends StatelessWidget {
  const AnimatedTxt({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            text,
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.end,
            colors: [Colors.grey.shade600, Colors.white, Colors.grey.shade900],
          ),
        ],
        // text: _kTexts,
        repeatForever: true,
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.screenWidth,
    required this.bloc,
  });

  final double screenWidth;
  final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      height: 83,
      decoration: BoxDecoration(
        color: AppColors.darker,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
        itemBuilder: (context, index) => SizedBox(
          width: screenWidth * .193,
          child: MaterialButton(
            onPressed: () => bloc.add(MainMenuButtonEvent(index: index)),
            splashColor: AppColors.transparentWhite,
            highlightColor: AppColors.transparentBlack,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // #menu_icon
                Image(
                  image: index + 1 == bloc.currentScreen ? bloc.listOfMenuIcons[index + 5] : bloc.listOfMenuIcons[index],
                  height: index + 1 == bloc.currentScreen ? 28 : 24,
                  width: index + 1 == bloc.currentScreen ? 28 : 24,
                  color: index + 1 == bloc.currentScreen ? AppColors.white : AppColors.lightGrey,
                ),

                // #menu_text
                Text(bloc.listOfMenuTexts[index].tr(),
                    style: index + 1 == bloc.currentScreen ? AppTextStyles.style21(context) : AppTextStyles.style22(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
    required this.textTitle,
    required this.textCancel,
    this.textDone,
    required this.functionCancel,
    this.functionDone,
    required this.child,
    this.doneButton = false,
    this.red = false,
  });

  final String textTitle;
  final String textCancel;
  final String? textDone;
  final Function functionCancel;
  final Function? functionDone;
  final Widget child;
  final bool doneButton;
  final bool red;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // #backgoround
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => functionCancel(),
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: AppColors.transparentBlack,
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: AppColors.transparent,
                child: Text(textTitle, style: AppTextStyles.style20(context), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              child,
              // #cancel_done_button
              Row(
                mainAxisAlignment: doneButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  red
                      ? Flexible(
                          child: SingleButton(
                            onPressed: () => functionCancel(),
                            red: true,
                            text: textCancel,
                          ),
                        )
                      : SelectButton(
                          context: context,
                          text: textCancel,
                          function: () => functionCancel(),
                          select: false,
                        ),
                  const SizedBox(width: 15),
                  if (doneButton)
                    red
                        ? Flexible(
                            child: SingleButton(
                              onPressed: () => functionDone!(),
                              red: true,
                              redDone: true,
                              text: textDone!,
                            ),
                          )
                        : SelectButton(
                            context: context,
                            text: textDone!,
                            function: () => functionDone!(),
                            select: true,
                            selectFunctionOn: true,
                          ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyProfileButton extends StatelessWidget {
  final Function function;
  final String text;
  final Widget endElement;

  const MyProfileButton({
    super.key,
    required this.text,
    required this.function,
    required this.endElement,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => function(),
      height: 44,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppTextStyles.style19(context)),
          endElement,
        ],
      ),
    );
  }
}

MaterialButton myNewInitialButton({required String ic, required String text, required Function function, required BuildContext context}) {
  return MaterialButton(
    onPressed: () => function(),
    height: 46,
    color: AppColors.gray,
    elevation: 0,
    highlightColor: AppColors.transparentBlack,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: Row(
      children: [
        Image(
          image: AssetImage('assets/icons/$ic.png'),
          height: 26,
          width: 26,
        ),
        const SizedBox(width: 10),
        Text(text, style: AppTextStyles.style24(context))
      ],
    ),
  );
}

class MyNewTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onChanged;
  final Function onSubmitted;
  final bool suffixIconDone;
  final String snackBarText;
  final TextInputType textInputType;
  final bool isMoney;

  const MyNewTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.suffixIconDone,
    required this.snackBarText,
    required this.textInputType,
    this.isMoney = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: controller.text.isNotEmpty || focusNode.hasFocus ? AppTextStyles.style26(context) : AppTextStyles.style25(context),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: title == 'address_organization'.tr() ? 66 : 44,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (v) => onChanged(),
            onTap: () => onChanged(),
            onSubmitted: (v) => onSubmitted(),
            style: AppTextStyles.style13(context),
            cursorColor: AppColors.white,
            maxLines: null,
            keyboardType: textInputType,
            textInputAction: TextInputAction.next,
            inputFormatters: textInputType == TextInputType.number
                ? [
                    isMoney
                        ? CurrencyInputFormatter(
                            trailingSymbol: 'uzs'.tr(),
                            useSymbolPadding: true,
                            mantissaLength: 0,
                            thousandSeparator: ThousandSeparator.Space,
                          )
                        : MaskedInputFormatter('000 000 000'),
                  ]
                : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
              suffixIcon: controller.text.isNotEmpty || focusNode.hasFocus
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => !suffixIconDone ? Utils.mySnackBar(context: context, txt: snackBarText, errorState: true) : {},
                      icon:
                          suffixIconDone ? Icon(Icons.done, color: AppColors.white) : const Icon(Icons.error_outline, color: AppColors.red),
                    )
                  : const SizedBox.shrink(),
              enabledBorder: myInputBorder(
                itsColor1: controller.text.isNotEmpty || focusNode.hasFocus,
                color1: AppColors.white,
                color2: AppColors.gray,
              ),
              focusedBorder: myInputBorder(color1: AppColors.white),
              errorBorder: myInputBorder(color1: AppColors.red),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyDropdownButton extends StatelessWidget {
  const MyDropdownButton({
    super.key,
    required this.status,
    required this.titleText,
    required this.focusNode,
    required this.statusList,
    required this.onChanged,
  });

  final String? status;
  final String titleText;
  final List<String> statusList;
  final FocusNode focusNode;
  final void Function(String status) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText, style: status == null ? AppTextStyles.style25(context) : AppTextStyles.style26(context)),
        const SizedBox(height: 4),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 44,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              width: 1.2,
              color: status == null ? AppColors.gray : AppColors.white,
            ),
          ),
          child: DropdownButton<String>(
            value: status,
            isExpanded: true,
            icon: const Icon(Icons.expand_circle_down_rounded),
            focusNode: focusNode,
            underline: const SizedBox.shrink(),
            padding: const EdgeInsets.only(left: 15, right: 10),
            borderRadius: BorderRadius.circular(6),
            dropdownColor: AppColors.dark,
            iconEnabledColor: status == null ? AppColors.gray : AppColors.white,
            selectedItemBuilder: (value) {
              return status != null
                  ? statusList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppTextStyles.style13(context)),
                      );
                    }).toList()
                  : [const DropdownMenuItem(child: SizedBox.shrink())];
            },
            items: statusList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: AppTextStyles.style23(context)),
              );
            }).toList(),
            onChanged: (status) => onChanged(status!),
          ),
        ),
      ],
    );
  }
}

class MyMonthDayButton extends StatelessWidget {
  const MyMonthDayButton({
    super.key,
    required this.onPressed,
    required this.weekDay,
    required this.monthDay,
    this.selected = false,
  });

  final Function onPressed;
  final String weekDay;
  final String monthDay;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darker,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 46,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () => onPressed(),
          height: 72,
          elevation: 0,
          color: selected ? AppColors.blue : AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // #weed_day
              Text(weekDay, style: selected ? AppTextStyles.style23_1(context).copyWith(color: Colors.white) : AppTextStyles.style25_1(context)),
              const SizedBox(height: 4),

              // #month_day
              Text(monthDay, style: selected ? AppTextStyles.style23_1(context).copyWith(color: Colors.white) : AppTextStyles.style25_1(context)),
              Divider(
                height: 10,
                color: selected ? Colors.white : AppColors.darkGrey,
                indent: 14,
                endIndent: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSearchButtons {
  Function functionFilter;
  Function functionSearch;

  FilterSearchButtons({required this.functionFilter, required this.functionSearch});
}

class MyInvoiceOrContractContainer extends StatelessWidget {
  final bool contract;
  final int index;
  final bool animatedDisabled;
  final int last;
  final void Function(BuildContext c) onPressed;
  final ContractModel? contractModel;
  final InvoiceModel? invoiceModel;
  final bool dismissible;
  final Function? dismissibleFunc;

  const MyInvoiceOrContractContainer({
    super.key,
    required this.contract,
    required this.index,
    required this.animatedDisabled,
    required this.last,
    required this.onPressed,
    this.contractModel,
    this.invoiceModel,
    this.dismissible = false,
    this.dismissibleFunc,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: Duration(milliseconds: animatedDisabled ? 0 : 50),
      child: SlideAnimation(
        duration: Duration(milliseconds: animatedDisabled ? 0 : 2000),
        curve: Curves.fastLinearToSlowEaseIn,
        horizontalOffset: 0,
        verticalOffset: 300.0,
        child: FlipAnimation(
          duration: Duration(milliseconds: animatedDisabled ? 0 : 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          flipAxis: FlipAxis.y,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: dismissible
                ? Dismissible(
                    key: Key(contract ? contractModel!.key! : invoiceModel!.key!),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async => await dismissibleFunc!(),
                    background: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('delete'.tr(), style: AppTextStyles.style23_2(context)),
                          const SizedBox(width: 5),
                          const Icon(Icons.delete_sweep, color: AppColors.red, size: 32),
                        ],
                      ),
                    ),
                    child: invoiceOrContainerChild(context),
                  )
                : invoiceOrContainerChild(context),
          ),
        ),
      ),
    );
  }

  MaterialButton invoiceOrContainerChild(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(context),
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.dark,
      child: SizedBox(
        height: 136,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // #number_status
            Row(
              children: [
                const Image(
                  image: AssetImage('assets/icons/ic_new_contract.png'),
                  height: 18,
                  width: 18,
                ),
                Text(' № ${contract ? contractModel!.number : invoiceModel!.number}', style: AppTextStyles.style23_1(context)),
                const Spacer(),
                Container(
                  height: 21,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: switch (contract ? contractModel!.status! : invoiceModel!.status!) {
                        'Paid' => AppColors.transparentBlueStatus,
                        'In process' => AppColors.transparentOrange,
                        String() => AppColors.transparentRedStatus,
                      },
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(contract ? contractModel!.status!.tr() : invoiceModel!.status!.tr(),
                      style: AppTextStyles.style27(context).copyWith(
                          color: switch (contract ? contractModel!.status! : invoiceModel!.status!) {
                        'Paid' => AppColors.blueStatus,
                        'In process' => AppColors.orange,
                        String() => AppColors.redStatus,
                      })),
                )
              ],
            ),
            const SizedBox(height: 5),

            // #fishers_full_name
            Row(
              children: [
                Text('${contract ? 'fishers_full_name'.tr() : 'service_name'.tr()}:  ', style: AppTextStyles.style19(context)),
                Flexible(
                    child: Text(contract ? contractModel!.fullName! : invoiceModel!.serviceName!,
                        style: AppTextStyles.style23(context), overflow: TextOverflow.ellipsis)),
              ],
            ),

            contract
                // #address
                ? Row(
                    children: [
                      Text('${'address_organization'.tr()}:  ', style: AppTextStyles.style19(context)),
                      Flexible(
                          child: Text('${contractModel!.address}', style: AppTextStyles.style23(context), overflow: TextOverflow.ellipsis)),
                    ],
                  )

                // #amount
                : Row(
                    children: [
                      Text('${'amount'.tr()}:  ', style: AppTextStyles.style19(context)),
                      Text('${invoiceModel!.amount} ${'uzs'.tr()}', style: AppTextStyles.style23(context)),
                    ],
                  ),

            // #number
            Row(
              children: [
                Text('${contract ? 'last_contract'.tr() : 'last_invoice'.tr()}:  ', style: AppTextStyles.style19(context)),
                Text('№ $last', style: AppTextStyles.style23(context)),
              ],
            ),

            // #number_created_time
            Row(
              children: [
                Text('${contract ? 'number_contract'.tr() : 'number_invoice'.tr()}:  ', style: AppTextStyles.style19(context)),
                Text(contract ? contractModel!.number.toString() : invoiceModel!.number.toString(), style: AppTextStyles.style23(context)),
                const Spacer(),
                Text(contract ? contractModel!.createdDate! : invoiceModel!.createdDate!, style: AppTextStyles.style25_2(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyFilterDatePickerButton extends StatelessWidget {
  final String text;
  final bool selected;
  final Function onPressed;

  const MyFilterDatePickerButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      padding: EdgeInsets.zero,
      minWidth: 165,
      child: SizedBox(
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // #icon
            Image(
              image: AssetImage('assets/icons/ic_done_${selected ? 'fill' : 'outlined'}.png'),
              height: 24,
              width: 24,
              color: selected ? AppColors.white : AppColors.lightGrey,
            ),
            const SizedBox(width: 8),
            // #text
            Text(text, style: selected ? AppTextStyles.style19(context) : AppTextStyles.style19_1(context)),
          ],
        ),
      ),
    );
  }
}

Theme myDatePickerTheme(Widget? child) => Theme(
      data: ThemeData.light().copyWith(
        primaryColor: AppColors.white,
        hintColor: AppColors.gray,
        colorScheme: ColorScheme.light(
          primary: AppColors.blue,
          onPrimary: AppColors.black,
          surface: AppColors.black,
          onSurface: AppColors.white,
        ),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child ?? Container(),
    );

class MyDateButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const MyDateButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 37,
      color: AppColors.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: text == 'to'.tr() ? AppTextStyles.style19_1(context) : AppTextStyles.style19(context)),
            Icon(Icons.calendar_month, size: 16, color: text == 'to'.tr() ? AppColors.lightGrey : AppColors.white),
          ],
        ),
      ),
    );
  }
}

class SingleButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool red;
  final bool redDone;

  const SingleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.red = false,
    this.redDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 40,
      minWidth: double.infinity,
      elevation: 0,
      color: redDone
          ? AppColors.red
          : red
              ? AppColors.transparentRed
              : AppColors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: red && !redDone ? AppTextStyles.style23_2(context) : AppTextStyles.style23_1(context).copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SingleRedButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const SingleRedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 40,
      minWidth: double.infinity,
      elevation: 0,
      color: AppColors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: AppTextStyles.style23_1(context),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.ctx,
    required this.text,
    required this.okFunction,
  });

  final BuildContext ctx;
  final String text;
  final Function okFunction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darker,
      surfaceTintColor: AppColors.darker,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      title: Center(
        child: Text(
          'Warning!',
          style: AppTextStyles.style3_1(context),
        ),
      ),
      content: Text(
        text,
        style: AppTextStyles.style26(context),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SelectButton(
          function: () => {
            Navigator.pop(ctx, true),
            okFunction(),
          },
          selectFunctionOn: true,
          context: context,
          select: true,
          text: 'done'.tr(),
        ),
      ],
    );
  }
}

enum StatusFilter { paid, inProcess, rejectedIQ, rejectedPayme }

class MyFilterPage extends StatelessWidget {
  final void Function() cancelPress;
  final void Function() applyPress;
  final void Function() removePress;
  final void Function(StatusFilter status) pressStatus;
  final bool filterPaid;
  final bool filterInProcess;
  final bool filterIQ;
  final bool filterPayme;
  final void Function(bool toDate) showDataPicker;
  final String selectedDateFilter;
  final String selectedDateFilterTo;

  const MyFilterPage({
    super.key,
    required this.cancelPress,
    required this.applyPress,
    required this.removePress,
    required this.pressStatus,
    required this.filterPayme,
    required this.filterPaid,
    required this.filterInProcess,
    required this.filterIQ,
    required this.showDataPicker,
    required this.selectedDateFilter,
    required this.selectedDateFilterTo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.darker,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24, color: AppColors.white),
            highlightColor: AppColors.white,
            onPressed: () => cancelPress(),
          ),
          centerTitle: true,
          title: Text('filters'.tr(), style: AppTextStyles.style18_0(context)),
          actions: [
            MaterialButton(
              onPressed: () => removePress(),
              child: Text('remove'.tr(), style: AppTextStyles.style23_2(context)),
            )
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Flexible(
                child: Container(
                  color: AppColors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('status'.tr(), style: AppTextStyles.style23_3(context)),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // #paid
                          MyFilterDatePickerButton(
                            text: 'Paid'.tr(),
                            onPressed: () => pressStatus(StatusFilter.paid),
                            selected: filterPaid,
                          ),
                          const SizedBox(width: 10),

                          // #rejected_iq
                          MyFilterDatePickerButton(
                            text: 'Rejected by IQ'.tr(),
                            onPressed: () => pressStatus(StatusFilter.rejectedIQ),
                            selected: filterIQ,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // #in_process
                          MyFilterDatePickerButton(
                            text: 'In process'.tr(),
                            onPressed: () => pressStatus(StatusFilter.inProcess),
                            selected: filterInProcess,
                          ),
                          const SizedBox(width: 10),

                          // #rejected_payme
                          MyFilterDatePickerButton(
                            text: 'Rejected by Payme'.tr(),
                            onPressed: () => pressStatus(StatusFilter.rejectedPayme),
                            selected: filterPayme,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // #date_text
                      Text('date'.tr(), style: AppTextStyles.style23_3(context)),
                      const SizedBox(height: 10),

                      // #date_buttons
                      Row(
                        children: [
                          MyDateButton(
                            onPressed: () => showDataPicker(false),
                            text: selectedDateFilter,
                          ),
                          Container(height: 2, width: 8, color: AppColors.white, margin: const EdgeInsets.symmetric(horizontal: 10)),
                          MyDateButton(
                            onPressed: () => showDataPicker(true),
                            text: selectedDateFilterTo,
                          ),
                        ],
                      ),
                      const Spacer(),

                      Row(
                        children: [
                          Flexible(
                            child: MyFilterButton(
                              function: () => cancelPress(),
                              text: 'cancel'.tr(),
                              enable: false,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: MyFilterButton(
                              function: () => applyPress(),
                              text: 'apply_filter'.tr(),
                              enable: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 83,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: AppColors.transparentBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MyNotFoundWidget extends StatelessWidget {
  final String text;

  const MyNotFoundWidget({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: AppColors.transparentWhite,
        highlightColor: AppColors.white,
        period: const Duration(seconds: 2),
        enabled: context.debugDoingBuild,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image(
                image: AssetImage('assets/icons/ic_not_found.png'),
                color: AppColors.lightGrey,
                height: 100,
                width: 100,
              ),
            ),
            Text(text, style: AppTextStyles.style18(context),)
          ],
        ),
      ),
    );
  }
}
