import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Application/Menus/View/Single/Bloc/single_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class SinglePage extends StatelessWidget {
  static const String id = '/single_page';
  final bool isContract;
  late final ContractModel contractModel;
  late final InvoiceModel invoiceModel;
  late final List<ContractModel> contracts;
  late final List<InvoiceModel> invoices;
  final bool history;
  final MainBloc mainBloc;

  SinglePage({
    super.key,
    required this.isContract,
    required this.mainBloc,
    this.history = false,
    this.contracts = const [],
    this.invoices = const [],
    ContractModel? contractModel,
    InvoiceModel? invoiceModel,
  }) {
    this.contractModel = contractModel ?? ContractModel();
    this.invoiceModel = invoiceModel ?? InvoiceModel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SingleBloc(
              mainBloc: mainBloc,
              isContract: isContract,
              contractModel: contractModel,
              invoiceModel: invoiceModel,
              contracts: contracts,
              invoices: invoices,
            ),
            child: BlocBuilder<SingleBloc, SingleState>(
              builder: (context, state) {
                SingleBloc bloc = context.read<SingleBloc>();
                if (bloc.initial) {
                  if (history) {
                    bloc.history = true;
                  } else {
                    bloc.add(SaveButtonEvent(initial: true, context: context));
                  }
                }
                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: AppColors.black,
                      appBar: AppBar(
                        backgroundColor: AppColors.darker,
                        surfaceTintColor: AppColors.black,
                        elevation: 2,
                        shadowColor: AppColors.gray,
                        leading: const SizedBox.shrink(),
                        leadingWidth: 0,
                        titleSpacing: 10,
                        title: Row(
                          children: [
                            // #icon
                            const SizedBox(width: 10),
                            const Image(
                              image: AssetImage('assets/icons/ic_new_contract.png'),
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 12),

                            // #title
                            Text(
                              '№ ${isContract ? bloc.contractModel.number : bloc.invoiceModel.number}',
                              style: AppTextStyles.style18_1(context),
                            ),

                            // #save
                            const Spacer(),
                            IconButton(
                              onPressed: () => bloc.add(SaveButtonEvent(context: context)),
                              highlightColor: AppColors.transparentWhite,
                              icon: Icon(
                                history
                                    ? Icons.auto_delete
                                    : (isContract
                                        ? mainBloc.savedContracts.contains(bloc.contractModel)
                                            ? Icons.bookmark
                                            : Icons.bookmark_border
                                        : mainBloc.savedInvoices.contains(bloc.invoiceModel)
                                            ? Icons.bookmark
                                            : Icons.bookmark_border),
                                size: 24,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: SingleChildScrollView(
                        controller: bloc.controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // #contract
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              height: 310,
                              decoration: BoxDecoration(
                                color: AppColors.dark,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius: 1.5,
                                    offset: const Offset(0, 2.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // #fishers_full_name_or_full_name
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${isContract ? 'fishers_full_name'.tr() : 'full_name'.tr()}:  ',
                                        style: AppTextStyles.style19(context),
                                      ),
                                      Flexible(
                                        child: Text(
                                          isContract ? bloc.contractModel.fullName! : bloc.invoiceModel.fullName!,
                                          style: AppTextStyles.style23(context),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // #status
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${'status'.tr()}:  ', style: AppTextStyles.style19(context)),
                                      Flexible(
                                        child: Text(
                                          isContract ? bloc.contractModel.status!.tr() : bloc.invoiceModel.status!.tr(),
                                          style: AppTextStyles.style23(context),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // #amount
                                  Row(
                                    children: [
                                      Text('${'amount'.tr()}:  ', style: AppTextStyles.style19(context)),
                                      Text('${isContract ? 5555 : bloc.invoiceModel.amount} ${'uzs'.tr()}', style: AppTextStyles.style23(context)),
                                    ],
                                  ),

                                  // #last_invoice
                                  Row(
                                    children: [
                                      Text('${'last_invoice'.tr()}:  ', style: AppTextStyles.style19(context)),
                                      Text('№ ${mainBloc.invoices.length}', style: AppTextStyles.style23(context)),
                                    ],
                                  ),

                                  // #number_of_invoice_or_contract
                                  Row(
                                    children: [
                                      Text(
                                        '${isContract ? 'number_contract'.tr() : 'number_invoice'.tr()}:  ',
                                        style: AppTextStyles.style19(context),
                                      ),
                                      Text(
                                        '${isContract ? bloc.contractModel.number : bloc.invoiceModel.number}',
                                        style: AppTextStyles.style23(context),
                                      ),
                                    ],
                                  ),

                                  // #address_or_service_name
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          '${isContract ? 'address_organization'.tr() : 'service_name'.tr()}:  ',
                                          style: AppTextStyles.style19(context),
                                          softWrap: true,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          '${isContract ? bloc.contractModel.address : bloc.invoiceModel.serviceName}',
                                          style: AppTextStyles.style23(context),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // #tin
                                  if (isContract)
                                    Row(
                                      children: [
                                        Text('${'tin_organization'.tr()}:  ', style: AppTextStyles.style19(context)),
                                        Text(bloc.contractModel.tin.toString(), style: AppTextStyles.style23(context)),
                                      ],
                                    ),

                                  // #created_at
                                  Row(
                                    children: [
                                      Text('${'created_at'.tr()}:  ', style: AppTextStyles.style19(context)),
                                      Text(
                                        isContract ? bloc.contractModel.createdDate! : bloc.invoiceModel.createdDate!,
                                        style: AppTextStyles.style23(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // #delete_create_buttons
                            if (!history)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // #delete_button
                                    Flexible(
                                      child: SingleButton(
                                        red: true,
                                        text: isContract ? 'delete_contract'.tr() : 'delete_invoice'.tr(),
                                        onPressed: () => bloc.add(DeleteButtonEvent()),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // #create_button
                                    Flexible(
                                      child: SingleButton(
                                        text: isContract ? 'create_contract'.tr() : 'create_invoice'.tr(),
                                        onPressed: () => bloc.add(CreateButtonEvent(context: context)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // #other_contracts_text
                            if (isContract && contracts.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text('other_contracts'.tr(), style: AppTextStyles.style20(context)),
                              ),

                            // #other_invoices_text
                            if (!isContract && invoices.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text('other_invoices'.tr(), style: AppTextStyles.style20(context)),
                              ),

                            // #other_contracts_or_invoices
                            SizedBox(
                              height: 162.0 * (isContract ? bloc.contracts.length : bloc.invoices.length),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: isContract ? bloc.contracts.length : bloc.invoices.length,
                                itemBuilder: (context, index) {
                                  return MyInvoiceOrContractContainer(
                                    contract: isContract,
                                    index: index,
                                    contractModel: isContract ? bloc.contracts[index] : null,
                                    invoiceModel: !isContract ? bloc.invoices[index] : null,
                                    last: isContract ? bloc.contracts.length : bloc.invoices.length,
                                    animatedDisabled: false,
                                    onPressed: (c) => bloc.add(SinglePageEvent(index: index)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // #delete_screen
                    if (state is SingleDeleteState)
                      MyProfileScreen(
                        red: true,
                        doneButton: true,
                        functionCancel: () => bloc.add(DeleteCancelEvent()),
                        functionDone: () => bloc.add(DeleteConfirmEvent(context: context)),
                        textCancel: 'cancel'.tr(),
                        textDone: 'done'.tr(),
                        textTitle: isContract ? 'delete_this_contract'.tr() : 'delete_this_invoice'.tr(),
                        child: const SizedBox.shrink(),
                      ),

                    // #loading_screen
                    if (state is SingleLoadingState) myIsLoading(context),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
