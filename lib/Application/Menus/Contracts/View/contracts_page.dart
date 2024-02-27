import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Menus/Contracts/Bloc/contracts_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class ContractsPage extends StatelessWidget {
  static const id = '/contracts_page';

  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContractsBloc(),
      child: BlocBuilder<ContractsBloc, ContractsState>(builder: (context, state) {
        ContractsBloc bloc = context.read<ContractsBloc>();
        bloc.dayController.addListener(() => context.read<ContractsBloc>()
            .add(ListenEvent(width: MediaQuery.of(context).size.width)));
        context.read<ContractsBloc>().add(InitialDayControllerEvent(width: MediaQuery.of(context).size.width));
        return  Scaffold(
          backgroundColor: AppColors.black,
          appBar: MyAppBar(
              titleText: 'contracts'.tr(),
              filterSearchButtons: FilterSearchButtons(
                  functionFilter: () => context.read<ContractsBloc>().add(FilterEvent()),
                  functionSearch: () => context.read<ContractsBloc>().add(SearchEvent()),
              ),
          ),

          body: Column(
            children: [
              Container(
                height: 150,
                color: AppColors.dark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // #month_year_buttons
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Row(
                          children: [

                            // #month_year
                            Text(
                              '${bloc.monthNames[bloc.selectedMonth - 1].tr()}, ${bloc.selectedYear}',
                              style: AppTextStyles.style18_1,
                            ),
                            const Spacer(),

                            // #buttons
                            IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                              highlightColor: AppColors.transparentWhite,
                              onPressed: () => context.read<ContractsBloc>()
                                  .add(MonthButtonEvent(left: true, width: MediaQuery.of(context).size.width)),
                              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              highlightColor: AppColors.transparentWhite,
                              onPressed: () => context.read<ContractsBloc>().add(MonthButtonEvent()),
                              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // #days
                    SizedBox(
                      height: 72,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return MyMonthDayButton(
                            onPressed: () => context.read<ContractsBloc>().add(DayButtonEvent(selectedDay: index + 1)),
                            weedDay: bloc.weekDaysName[index % 7].tr(),
                            monthDay: (index + 1).toString(),
                            selected: index + 1 == bloc.selectedDay,
                          );
                        },
                        dragStartBehavior: DragStartBehavior.down,
                        controller: bloc.dayController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: bloc.monthDays[bloc.selectedMonth - 1] == 28 && bloc.selectedYear == 2024
                            ? 29
                            : bloc.monthDays[bloc.selectedMonth - 1],
                      )

                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    ));
  }
}