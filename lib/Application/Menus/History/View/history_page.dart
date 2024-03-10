import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/History/Bloc/history_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class HistoryPage extends StatelessWidget {
  static const id = '/history_page';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final MainBloc mainBloc = context.read<MainBloc>();
        return BlocProvider(
          create: (context) => HistoryBloc(mainBloc: mainBloc),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              HistoryBloc bloc = context.read<HistoryBloc>();
              if (bloc.initial) {
                bloc.add(InitialEvent());
              }
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.transparent,
                    appBar: MyAppBar(
                      titleText: 'history'.tr(),
                      filterSearchButtons: FilterSearchButtons(
                        functionFilter: () => bloc.add(FilterEvent()),
                        functionSearch: () => bloc.add(SearchEvent(context: context)),
                        ),
                    ),
                    body: CustomScrollView(
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
                                SelectButton(
                                  function: () => bloc.add(const ContractOrInvoiceEvent(contract: true)),
                                  text: 'contract'.tr(),
                                  select: bloc.contractButtonSelect,
                                  context: context,
                                ),
                                const SizedBox(width: 16),
                                SelectButton(
                                  function: () => bloc.add(const ContractOrInvoiceEvent()),
                                  text: 'invoice'.tr(),
                                  select: !bloc.contractButtonSelect,
                                  context: context,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                height: (bloc.contractButtonSelect
                                ? bloc.historyContracts.length
                                : bloc.historyInvoices.length) * 162 + 83,
                                child: ReorderableListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (bloc.filterEnabled
                                      ? bloc.contractButtonSelect
                                          ? bloc.filterContracts.length
                                          : bloc.filterInvoices.length
                                      : bloc.contractButtonSelect
                                          ? bloc.historyContracts.length
                                          : bloc.historyInvoices.length),
                                  onReorder: (int oldIndex, int newIndex) =>
                                      bloc.add(OnReorderEvent(newIndex: newIndex, oldIndex: oldIndex)),
                                  itemBuilder: (BuildContext c, int index) {
                                    return bloc.contractButtonSelect

                                        // #contract_container
                                        ? MyInvoiceOrContractContainer(
                                            key: Key(
                                              bloc.filterEnabled ? bloc.filterContracts[index].key! : bloc.historyContracts[index].key!,
                                            ),
                                            contract: true,
                                            animatedDisabled: false,
                                            index: index,
                                            contractModel: bloc.filterEnabled ? bloc.filterContracts[index] : bloc.historyContracts[index],
                                            last: mainBloc.contracts.length,
                                            onPressed: (c) =>
                                                bloc.add(SinglePageEvent(context: context, index: index, filter: bloc.filterEnabled)),
                                          )

                                        // #invoice_container
                                        : MyInvoiceOrContractContainer(
                                            key: Key(
                                              bloc.filterEnabled ? bloc.filterInvoices[index].key! : bloc.historyInvoices[index].key!,
                                            ),
                                            contract: false,
                                            animatedDisabled: false,
                                            index: index,
                                            invoiceModel: bloc.filterEnabled ? bloc.filterInvoices[index] : bloc.historyInvoices[index],
                                            last: mainBloc.invoices.length,
                                            onPressed: (c) =>
                                                bloc.add(SinglePageEvent(context: context, index: index, filter: bloc.filterEnabled)),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // #filter_screen
                  if (state is HistoryFilterState)
                    MyFilterPage(
                      cancelPress: () => bloc.add(const CancelFilterEvent()),
                      applyPress: () => bloc.add(ApplyFilterEvent(context: context)),
                      removePress: () => bloc.add(const CancelFilterEvent(remove: true)),
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
                  if (state is HistoryLoadingState) myIsLoading(context),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
