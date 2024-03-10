import 'package:feature_discovery/feature_discovery.dart';
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
    return FeatureDiscovery(
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
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
              if (widget.key == const Key('1')) {
                bloc.dayController
                    .addListener(() => context.read<ContractsBloc>().add(ListenEvent(width: MediaQuery.of(context).size.width)));
                context.read<ContractsBloc>().add(InitialDayControllerEvent(width: MediaQuery.of(context).size.width));
                context.read<ContractsBloc>().add(ContractOrInvoiceEvent(first: true, context: context));
              }
            }

            return Stack(
              children: [
                // #default_screen
                Scaffold(
                  backgroundColor: AppColors.transparent,
                  appBar: MyAppBar(
                    titleText: 'contracts'.tr(),
                    filterSearchButtons: FilterSearchButtons(
                      functionFilter: () => bloc.add(FilterEvent()),
                      functionSearch: () => bloc.add(SearchEvent(context: context)),
                    ),
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // #day_month_year
                      if (!bloc.filterEnabled)
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
                                        style: AppTextStyles.style18_1(context),
                                      ),
                                      const Spacer(),

                                      // #buttons_left_right
                                      DescribedFeatureOverlay(
                                        featureId: 'feature1',
                                        tapTarget: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(width: 15),
                                            Icon(Icons.arrow_back_ios, color: AppColors.white),
                                          ],
                                        ),
                                        allowShowingDuplicate: true,
                                        contentLocation: ContentLocation.below,
                                        title: Text('previous_month'.tr(), style: AppTextStyles.style11(context)),
                                        description: Text('previous_month_info'.tr(), style: AppTextStyles.style8(context)),
                                        backgroundColor: AppColors.blue,
                                        targetColor: AppColors.black,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.centerRight,
                                          highlightColor: AppColors.transparentWhite,
                                          onPressed: () => bloc.add(MonthButtonEvent(left: true, width: MediaQuery.of(context).size.width)),
                                          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                                        ),
                                      ),
                                      DescribedFeatureOverlay(
                                        featureId: 'feature2',
                                        allowShowingDuplicate: true,
                                        tapTarget: Icon(Icons.arrow_forward_ios, color: AppColors.white),
                                        contentLocation: ContentLocation.below,
                                        title: Text('next_month'.tr(), style: AppTextStyles.style11(context)),
                                        description: Text('next_month_info'.tr(), style: AppTextStyles.style8(context)),
                                        backgroundColor: AppColors.blue,
                                        targetColor: AppColors.black,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          highlightColor: AppColors.transparentWhite,
                                          onPressed: () => bloc.add(MonthButtonEvent()),
                                          icon: Icon(Icons.arrow_forward_ios, color: AppColors.white),
                                        ),
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
                                  DescribedFeatureOverlay(
                                    featureId: 'feature3',
                                    tapTarget: const SizedBox.shrink(),
                                    allowShowingDuplicate: true,
                                    overflowMode: OverflowMode.extendBackground,
                                    contentLocation: ContentLocation.below,
                                    title: Text('day_buttons'.tr(), style: AppTextStyles.style11(context)),
                                    description: Text('day_buttons_info'.tr(), style: AppTextStyles.style8(context)),
                                    backgroundColor: AppColors.blue,
                                    targetColor: AppColors.black,
                                    child: SizedBox(
                                      height: 72,
                                      child: ListView.builder(
                                        key: widget.key,
                                        itemBuilder: (BuildContext context, int index) {
                                          return MyMonthDayButton(
                                            onPressed: () => bloc.add(DayButtonEvent(selectedDay: index + 1)),
                                            weekDay:
                                                LogicService.weekDayName(year: bloc.selectedYear, month: bloc.selectedMonth, day: index + 1)
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // #contracts_invoices
                      RefreshIndicator(
                        onRefresh: () async =>
                            bloc.add(ContractOrInvoiceEvent(contract: bloc.contractButtonSelect, network: true, context: context)),
                        color: AppColors.blue,
                        backgroundColor: AppColors.transparentBlue,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - (bloc.filterEnabled ? 170 : 320),
                          child: CustomScrollView(
                            controller: bloc.invoiceController,
                            slivers: [
                              // #contracts_invoices_button
                              SliverAppBar(
                                expandedHeight: 67,
                                titleSpacing: 16,
                                backgroundColor: AppColors.black,
                                surfaceTintColor: AppColors.black,
                                pinned: false,
                                snap: true,
                                floating: true,
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                                  child: Row(
                                    children: [
                                      DescribedFeatureOverlay(
                                        featureId: 'feature4',
                                        tapTarget: const SizedBox.shrink(),
                                        allowShowingDuplicate: true,
                                        overflowMode: OverflowMode.extendBackground,
                                        contentLocation: ContentLocation.below,
                                        title: Text('contracts'.tr(), style: AppTextStyles.style11(context)),
                                        description: Text('contract_info'.tr(), style: AppTextStyles.style8(context)),
                                        backgroundColor: AppColors.blue,
                                        targetColor: AppColors.black,
                                        child: SelectButton(
                                          function: () => bloc.add(ContractOrInvoiceEvent(contract: true, context: context)),
                                          text: 'contract'.tr(),
                                          select: bloc.contractButtonSelect,
                                          context: context,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      DescribedFeatureOverlay(
                                        featureId: 'feature5',
                                        tapTarget: const SizedBox.shrink(),
                                        allowShowingDuplicate: true,
                                        overflowMode: OverflowMode.extendBackground,
                                        contentLocation: ContentLocation.below,
                                        title: Text('invoices'.tr(), style: AppTextStyles.style11(context)),
                                        description: Text('invoice_info'.tr(), style: AppTextStyles.style8(context)),
                                        backgroundColor: AppColors.blue,
                                        targetColor: AppColors.black,
                                        child: SelectButton(
                                          function: () => bloc.add(ContractOrInvoiceEvent(contract: false, context: context)),
                                          text: 'invoice'.tr(),
                                          select: !bloc.contractButtonSelect,
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SliverList(
                                delegate: SliverChildListDelegate([
                                  SizedBox(
                                    height: bloc.filterEnabled
                                        ? (bloc.contractButtonSelect ? bloc.filterContracts.length : bloc.filterInvoices.length) * 162 <
                                                (MediaQuery.of(context).size.height - 235)
                                            ? MediaQuery.of(context).size.height - 235
                                            : (bloc.contractButtonSelect ? bloc.filterContracts.length : bloc.filterInvoices.length) * 162
                                        : (bloc.contractButtonSelect ? bloc.filterContracts.length : bloc.filterInvoices.length) * 162 <
                                                (MediaQuery.of(context).size.height - 387)
                                            ? MediaQuery.of(context).size.height - 386
                                            : (bloc.contractButtonSelect
                                                    ? mainBloc.filterContracts.length
                                                    : mainBloc.filterInvoices.length) *
                                                162,
                                    child: ReorderableListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: (bloc.filterEnabled
                                          ? bloc.contractButtonSelect
                                              ? bloc.filterContracts.length
                                              : bloc.filterInvoices.length
                                          : bloc.contractButtonSelect
                                              ? mainBloc.filterContracts.length
                                              : mainBloc.filterInvoices.length),
                                      onReorder: (int oldIndex, int newIndex) =>
                                          bloc.add(OnReorderEvent(newIndex: newIndex, oldIndex: oldIndex)),
                                      itemBuilder: (BuildContext c, int index) {
                                        return bloc.contractButtonSelect

                                            // #contract_container
                                            ? MyInvoiceOrContractContainer(
                                                key: Key(
                                                  bloc.filterEnabled
                                                      ? bloc.filterContracts[index].key!
                                                      : mainBloc.filterContracts[index].key!,
                                                ),
                                                contract: true,
                                                animatedDisabled: widget.key == const Key('2'),
                                                index: index,
                                                contractModel:
                                                    bloc.filterEnabled ? bloc.filterContracts[index] : mainBloc.filterContracts[index],
                                                last: mainBloc.contracts.length,
                                                onPressed: (c) => bloc.add(SinglePageEvent(index: index, context: c)),
                                              )

                                            // #invoice_container
                                            : MyInvoiceOrContractContainer(
                                                key: Key(
                                                  bloc.filterEnabled
                                                      ? bloc.filterInvoices[index].key!
                                                      : mainBloc.filterInvoices[index].key!,
                                                ),
                                                contract: false,
                                                animatedDisabled: widget.key == const Key('2'),
                                                index: index,
                                                invoiceModel:
                                                    bloc.filterEnabled ? bloc.filterInvoices[index] : mainBloc.filterInvoices[index],
                                                last: mainBloc.invoices.length,
                                                onPressed: (c) => bloc.add(SinglePageEvent(index: index, context: c)),
                                              );
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // #filter_screen
                if (state is ContractsFilterState)
                  MyFilterPage(
                    cancelPress: () => bloc.add(CancelFilterEvent()),
                    applyPress: () => bloc.add(ApplyFilterEvent(context: context)),
                    removePress: () => bloc.add(CancelFilterEvent(remove: true, width: MediaQuery.of(context).size.width)),
                    pressStatus: (StatusFilter status) => bloc.add(StatusFilterEvent(status: status)),
                    filterInProcess: bloc.filterInProcess,
                    filterIQ: bloc.filterIQ,
                    filterPaid: bloc.filterPaid,
                    filterPayme: bloc.filterPayme,
                    showDataPicker: (bool toDate) => bloc.add(ShowDatePickerEvent(context: context, toDate: toDate)),
                    selectedDateFilter: bloc.selectedDateFilter,
                    selectedDateFilterTo: bloc.selectedDateFilterTo,
                  ),

                // #loading_screen
                if (state is ContractsLoadingState) myIsLoading(context),
              ],
            );
          }),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
