import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/util_service.dart';

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
      elevation: 0,
      backgroundColor: AppColors.black,
      surfaceTintColor: AppColors.black,
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
          Text(titleText, style: AppTextStyles.style18),

          if (filterSearchButtons != null)
            Flexible(
              child: Row(
                children: [
                  // #filter
                  const Spacer(),
                  IconButton(
                      onPressed: () => filterSearchButtons!.functionFilter(),
                      highlightColor: AppColors.transparentWhite,
                      icon: const Image(image: AssetImage('assets/icons/ic_filter.png'), width: 22, height: 22, color: AppColors.white)
                  ),

                  // #divider_vertical
                  const SizedBox(width: 10, height: 20, child: Divider(thickness: 20, color: AppColors.white, indent: 4, endIndent: 4)),

                  // #search
                  IconButton(
                      onPressed: () => filterSearchButtons!.functionSearch(),
                      highlightColor: AppColors.transparentWhite,
                      icon: const Icon(CupertinoIcons.search, color: AppColors.white)
                  ),
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
      decoration: const BoxDecoration(
        color: AppColors.darker,
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
                  image: index + 1 == bloc.currentScreen
                      ? bloc.listOfMenuIcons[index + 5]
                      : bloc.listOfMenuIcons[index],
                  height: index + 1 == bloc.currentScreen ? 28 : 24,
                  width: index + 1 == bloc.currentScreen ? 28 : 24,
                ),

                // #menu_text
                Text(
                    bloc.listOfMenuTexts[index].tr(),
                    style: index + 1 == bloc.currentScreen
                        ? AppTextStyles.style21
                        :AppTextStyles.style22
                ),
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
  });

  final String textTitle;
  final String textCancel;
  final String? textDone;
  final Function functionCancel;
  final Function? functionDone;
  final Widget child;
  final bool doneButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        // #backgoround
        InkWell(
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

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(textTitle, style: AppTextStyles.style20),
              const SizedBox(height: 16),
              child,
              // #cancel_done_button
              Row(
                mainAxisAlignment: doneButton
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  SelectButton(
                      context: context,
                      text: textCancel,
                      function: () => functionCancel(),
                      select: false,
                  ),

                  if(doneButton)
                    SelectButton(
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
          Text(text, style: AppTextStyles.style19),
          endElement,
        ],
      ),
    );
  }
}

MaterialButton myNewInitialButton({required String ic, required String text, required Function function}) {
  return MaterialButton(
    onPressed: () => function(),
    height: 46,
    color: AppColors.gray,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: Row(
      children: [
        Image(
          image: AssetImage('assets/icons/$ic.png'),
          height: 26,
          width: 26,
        ),
        const SizedBox(width: 10),
        Text(text, style: AppTextStyles.style24)
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
          style: controller.text.isNotEmpty || focusNode.hasFocus ? AppTextStyles.style26 : AppTextStyles.style25,
        ),
        const SizedBox(height: 4),

        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (v) => onChanged(),
            onTap: () => onChanged(),
            onSubmitted: (v) => onSubmitted(),
            style: AppTextStyles.style7,
            cursorColor: AppColors.blue,
            keyboardType: textInputType,
            textInputAction: TextInputAction.next,
            inputFormatters: textInputType == TextInputType.number
                ? [
                  isMoney
                      ? CurrencyInputFormatter(
                          trailingSymbol: 'uzs'.tr(),
                          useSymbolPadding: true,
                          mantissaLength: 0,
                          thousandSeparator:
                          ThousandSeparator.Space,
                  ) : MaskedInputFormatter('000 000 000'),
                  ]
                : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15, right: 10),
              suffixIcon: controller.text.isNotEmpty || focusNode.hasFocus
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => !suffixIconDone
                        ? Utils.mySnackBar(context: context, txt: snackBarText, errorState: true)
                        : {},
                      icon: suffixIconDone
                        ? const Icon(Icons.done, color: AppColors.blue)
                        : const Icon(Icons.error_outline,color: AppColors.red),
                  )
                  : const SizedBox.shrink(),
              enabledBorder: myInputBorder(
                itsColor1: controller.text.isNotEmpty || focusNode.hasFocus,
                color1: AppColors.blue,
                color2: AppColors.gray,
              ),
              focusedBorder: myInputBorder(color1: AppColors.blue),
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
        Text(titleText, style: status == null ? AppTextStyles.style25 : AppTextStyles.style26),
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
              color: status == null
                  ? AppColors.gray
                  : AppColors.blue,
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
            iconEnabledColor: status == null ? AppColors.gray : AppColors.blue,
            selectedItemBuilder: (value) {
              return status != null
                  ? statusList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTextStyles.style7),
                );
              }).toList()
                  : [const DropdownMenuItem(child: SizedBox.shrink())];
            },
            items: statusList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: AppTextStyles.style23),
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
    required this.weedDay,
    required this.monthDay,
    this.selected = false,
  });

  final Function onPressed;
  final String weedDay;
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
              Text(weedDay, style: selected ? AppTextStyles.style23_1 : AppTextStyles.style25_1),
              const SizedBox(height: 4),

              // #month_day
              Text(monthDay, style: selected ? AppTextStyles.style23_1 : AppTextStyles.style25_1),
              Divider(
                height: 10,
                color: selected ? AppColors.white : AppColors.darkGrey,
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

class MyInvoiceContainer extends StatelessWidget {
  final int index;
  final int number;
  final String status;
  final String fullName;
  final String amount;
  final String lastInvoice;
  final String numberOfInvoices;
  final String createdDate;
  final Function onPressed;
  final bool animatedDisabled;

  const MyInvoiceContainer({
    super.key,
    required this.index,
    required this.number,
    required this.status,
    required this.fullName,
    required this.amount,
    required this.lastInvoice,
    required this.numberOfInvoices,
    required this.createdDate,
    required this.onPressed,
    required this.animatedDisabled,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: MaterialButton(
              onPressed: () => onPressed(),
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
                        Text(' № $number', style: AppTextStyles.style23_1),
                        const Spacer(),

                        Container(
                          height: 21,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.disableBlue,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(status, style: AppTextStyles.style27),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),

                    // #fishers_full_name
                    Row(
                      children: [
                        Text('${'fishers_full_name'.tr()}:  ', style: AppTextStyles.style19),
                        Text(fullName, style: AppTextStyles.style23),
                      ],
                    ),

                    // #amount
                    Row(
                      children: [
                        Text('${'amount'.tr()}:  ', style: AppTextStyles.style19),
                        Text('$amount ${'uzs'.tr()}', style: AppTextStyles.style23),
                      ],
                    ),

                    // #number
                    Row(
                      children: [
                        Text('${'last_invoice'.tr()}:  ', style: AppTextStyles.style19),
                        Text('№ $lastInvoice', style: AppTextStyles.style23),
                      ],
                    ),

                    // #number_created_time
                    Row(
                      children: [
                        Text('${'number_invoice'.tr()}:  ', style: AppTextStyles.style19),
                        Text(numberOfInvoices, style: AppTextStyles.style23),

                        const Spacer(),
                        Text(createdDate, style: AppTextStyles.style25_2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}