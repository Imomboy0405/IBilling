import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/Contracts/Bloc/contracts_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';
import 'package:i_billing/Data/Service/logic_service.dart';
import 'package:lottie/lottie.dart';

class ContractsPage extends StatefulWidget {
  static const id = '/contracts_page';

  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> with AutomaticKeepAliveClientMixin {
  static bool first = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      final mainBloc = BlocProvider.of<MainBloc>(context);
      return BlocProvider(
            create: (context) => ContractsBloc(mainBloc: mainBloc),
            child: BlocBuilder<ContractsBloc, ContractsState>(builder: (context, state) {
              ContractsBloc bloc = context.read<ContractsBloc>();
              if (widget.key == const Key('2') && !first) {
                context.read<ContractsBloc>().add(InitialDay2ControllerEvent(position: mainBloc.dayControllerPixels));
              }
              if (first) {
                first = false;
                if(widget.key == const Key('1')) {
                  bloc.dayController
                      .addListener(() => context.read<ContractsBloc>().add(ListenEvent(width: MediaQuery.of(context).size.width)));
                  context.read<ContractsBloc>().add(InitialDayControllerEvent(width: MediaQuery.of(context).size.width));
                  context.read<ContractsBloc>().add(GetInvoicesEvent());
                }
              }

              return Stack(
                children: [
                  Scaffold(
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
                          color: AppColors.darker,
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
                                        '${bloc.monthNames[mainBloc.selectedMonth - 1].tr()}, ${mainBloc.selectedYear}',
                                        style: AppTextStyles.style18_1,
                                      ),
                                      const Spacer(),

                                      // #buttons_left_right
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerRight,
                                        highlightColor: AppColors.transparentWhite,
                                        onPressed: () => context
                                            .read<ContractsBloc>()
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

                              // #day_buttons
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  // #animations
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Lottie.asset(
                                      'assets/animations/animation_right_light.json',
                                      width: 72,
                                      height: 72,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Lottie.asset(
                                      'assets/animations/animation_left_light.json',
                                      width: 72,
                                      height: 72,
                                    ),
                                  ),

                                  // #day_buttons
                                  SizedBox(
                                      height: 72,
                                      child: ListView.builder(
                                        key: widget.key,
                                        itemBuilder: (BuildContext context, int index) {
                                          return MyMonthDayButton(
                                            onPressed: () =>
                                                context.read<ContractsBloc>().add(DayButtonEvent(selectedDay: index + 1)),
                                            weedDay: LogicService.weekDayName(
                                                    year: bloc.selectedYear, month: bloc.selectedMonth, day: index + 1)
                                                .tr(),
                                            monthDay: (index + 1).toString(),
                                            selected: index + 1 == mainBloc.selectedDay,
                                          );
                                        },
                                        dragStartBehavior: DragStartBehavior.down,
                                        controller: widget.key == const Key('2') ? bloc.dayController2 : bloc.dayController,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: bloc.monthDays[bloc.selectedMonth - 1] == 28 && bloc.selectedYear == 2024
                                            ? 29
                                            : bloc.monthDays[bloc.selectedMonth - 1],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async => context.read<ContractsBloc>().add(GetInvoicesEvent()),
                          color: AppColors.blue,
                          backgroundColor: AppColors.disableBlue,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 320,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height - 320,
                                  child: ReorderableListView.builder(
                                    scrollController: bloc.invoiceController,
                                    itemCount: mainBloc.invoices.length + 1,
                                    onReorder: (int oldIndex, int newIndex) => context
                                        .read<ContractsBloc>()
                                        .add(OnReorderEvent(newIndex: newIndex - 1, oldIndex: oldIndex - 1)),
                                    itemBuilder: (BuildContext c, int index) {
                                      return index == 0
                                          ? Row(
                                              key: const Key('0'),
                                              children: [
                                                SelectButton(
                                                  function: () {},
                                                  text: 'contracts'.tr(),
                                                  select: true,
                                                  context: context,
                                                )
                                              ],
                                            )
                                          : MyInvoiceContainer(
                                              key: Key(index.toString()),
                                              animatedDisabled: widget.key == const Key('2'),
                                              index: index - 1,
                                              onPressed: () {},
                                              number: mainBloc.invoices[index - 1].number!,
                                              status: mainBloc.invoices[index - 1].status!.tr(),
                                              fullName: mainBloc.invoices[index - 1].fullName!,
                                              amount: mainBloc.invoices[index - 1].amount.toString(),
                                              lastInvoice: '0',
                                              numberOfInvoices: '0',
                                              createdDate: mainBloc.invoices[index - 1].createdDate!,
                                            );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is ContractsLoadingState) myIsLoading(context),
                ],
              );
            }));
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}
