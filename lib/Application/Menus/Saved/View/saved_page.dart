import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/Saved/Bloc/saved_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class SavedPage extends StatelessWidget {
  static const id = '/saved_page';

  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final MainBloc mainBloc = context.read<MainBloc>();
        return BlocProvider(
          create: (context) => SavedBloc(mainBloc: mainBloc),
          child: BlocBuilder<SavedBloc, SavedState>(
            builder: (context, state) {
              SavedBloc bloc = context.read<SavedBloc>();
              if (bloc.initial) {
                bloc.add(InitialEvent());
              }
              if (bloc.singlePagePop) {
                bloc.add(InitialEvent());
              }
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.transparent,
                    appBar: MyAppBar(
                      titleText: 'saved'.tr(),
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
                                height: 500,
                                child: ReorderableListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (bloc.filterEnabled
                                      ? bloc.contractButtonSelect
                                          ? bloc.filterContracts.length
                                          : bloc.filterInvoices.length
                                      : bloc.contractButtonSelect
                                          ? bloc.savedContracts.length
                                          : bloc.savedInvoices.length),
                                  onReorder: (int oldIndex, int newIndex) =>
                                      bloc.add(OnReorderEvent(newIndex: newIndex, oldIndex: oldIndex)),
                                  itemBuilder: (BuildContext c, int index) {
                                    return bloc.contractButtonSelect

                                        // #contract_container
                                        ? MyInvoiceOrContractContainer(
                                            key: Key(
                                              bloc.filterEnabled
                                                  ? bloc.filterContracts[index].key!
                                                  : bloc.savedContracts[index].key!,
                                            ),
                                            contract: true,
                                            animatedDisabled: false,
                                            index: index,
                                            contractModel:
                                                bloc.filterEnabled ? bloc.filterContracts[index] : bloc.savedContracts[index],
                                            last: mainBloc.contracts.length,
                                            onPressed: (c) => bloc
                                                .add(SinglePageEvent(context: context, index: index, filter: bloc.filterEnabled)),
                                            dismissible: true,
                                            dismissibleFunc: () => bloc.add(DeleteEvent(
                                              model:
                                                  bloc.filterEnabled ? bloc.filterContracts[index] : bloc.savedContracts[index],
                                            )),
                                          )

                                        // #invoice_container
                                        : MyInvoiceOrContractContainer(
                                            key: Key(
                                              bloc.filterEnabled
                                                  ? bloc.filterInvoices[index].key!
                                                  : bloc.savedInvoices[index].key!,
                                            ),
                                            contract: false,
                                            animatedDisabled: false,
                                            index: index,
                                            invoiceModel:
                                                bloc.filterEnabled ? bloc.filterInvoices[index] : bloc.savedInvoices[index],
                                            last: mainBloc.invoices.length,
                                            onPressed: (c) => bloc
                                                .add(SinglePageEvent(context: context, index: index, filter: bloc.filterEnabled)),
                                            dismissible: true,
                                            dismissibleFunc: () => bloc.add(DeleteEvent(
                                              model: bloc.filterEnabled ? bloc.filterInvoices[index] : bloc.savedInvoices[index],
                                            )),
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
                  if (state is SavedFilterState)
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
                  if (state is SavedLoadingState) myIsLoading(context),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
