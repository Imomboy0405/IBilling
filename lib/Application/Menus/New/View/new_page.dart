import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Menus/New/Bloc/new_bloc.dart';
import 'package:i_billing/Application/Menus/View/menus_widgets.dart';
import 'package:i_billing/Application/Welcome/View/welcome_widgets.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';
import 'package:i_billing/Data/Service/lang_service.dart';

class NewPage extends StatelessWidget {
  static const id = '/new_page';

  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewBloc(),
      child: BlocBuilder<NewBloc, NewState>(builder: (context, state) {
        NewBloc bloc = context.read<NewBloc>();
        return Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: MyAppBar(
              titleText: state is NewInvoiceState
                  ? 'new_invoice'.tr()
                  : state is NewContractState
                      ? 'new_contract'.tr()
                      : 'a_new'.tr()),
          body: state is NewInitialState
              ? Stack(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 83),
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('what_create'.tr(), style: AppTextStyles.style20),
                            const SizedBox(height: 30),

                            // #contract_button
                            myNewInitialButton(
                              text: 'contract'.tr(),
                              ic: 'ic_new_contract',
                              function: () => context.read<NewBloc>().add(ContractEvent()),
                            ),
                            const SizedBox(height: 15),

                            // #invoice_button
                            myNewInitialButton(
                              text: 'invoice'.tr(),
                              ic: 'ic_new_invoice',
                              function: () => context.read<NewBloc>().add(InvoiceEvent()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : state is NewInvoiceState
                  // #invoice_screen
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // #service_name
                          MyNewTextField(
                            title: 'service_name'.tr(),
                            controller: bloc.serviceNameController,
                            focusNode: bloc.focusService,
                            textInputType: TextInputType.name,
                            onChanged: () => context.read<NewBloc>().add(InvoiceChange()),
                            onSubmitted: () => context.read<NewBloc>().add(InvoiceSubmitted(service: true)),
                            suffixIconDone: bloc.suffixServiceName,
                            snackBarText: 'snack_service'.tr(),
                          ),

                          // #invoice_amount
                          MyNewTextField(
                            title: 'invoice_amount'.tr(),
                            controller: bloc.invoiceAmountController,
                            focusNode: bloc.focusInvoice,
                            textInputType: TextInputType.number,
                            onChanged: () => context.read<NewBloc>().add(InvoiceChange()),
                            onSubmitted: () => context.read<NewBloc>().add(InvoiceSubmitted(context: context)),
                            suffixIconDone: bloc.suffixInvoiceAmount,
                            snackBarText: 'snack_invoice'.tr(),
                          ),

                          // #status_of_the_invoice
                          MyDropdownButton(
                            titleText: 'status_invoice'.tr(),
                            focusNode: bloc.focusStatus,
                            status: bloc.status,
                            statusList: bloc.statusList,
                            onChanged: (status) => context.read<NewBloc>().add(InvoiceStatus(status: status)),
                          ),
                          const SizedBox(height: 10),

                          MyButton(
                            text: 'save_invoice'.tr(),
                            function: () => context.read<NewBloc>().add(InvoiceSave()),
                            enable: bloc.suffixInvoiceAmount && bloc.suffixServiceName && bloc.status != null,
                          )
                        ],
                      ),
                    )

                  // #contract_screen
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // #face
                          MyDropdownButton(
                            titleText: 'face'.tr(),
                            focusNode: bloc.focusFace,
                            status: bloc.face,
                            statusList: bloc.faceStatusList,
                            onChanged: (status) => context.read<NewBloc>().add(ContractFaceStatus(status: status)),
                          ),

                          // #fisher_full_name
                          MyNewTextField(
                            title: 'fisher_full_name'.tr(),
                            controller: bloc.fullNameController,
                            focusNode: bloc.focusFullName,
                            textInputType: TextInputType.name,
                            onChanged: () => context.read<NewBloc>().add(ContractChange()),
                            onSubmitted: () => context.read<NewBloc>().add(ContractSubmitted(fullName: true)),
                            suffixIconDone: bloc.suffixFullName,
                            snackBarText: 'snack_full_name'.tr(),
                          ),

                          // #address_organization
                          MyNewTextField(
                            title: 'address_organization'.tr(),
                            controller: bloc.addressController,
                            focusNode: bloc.focusAddress,
                            textInputType: TextInputType.name,
                            onChanged: () => context.read<NewBloc>().add(ContractChange()),
                            onSubmitted: () => context.read<NewBloc>().add(ContractSubmitted(address: true)),
                            suffixIconDone: bloc.suffixAddress,
                            snackBarText: 'snack_address'.tr(),
                          ),

                          // #tin
                          MyNewTextField(
                            title: 'tin'.tr(),
                            controller: bloc.tINController,
                            focusNode: bloc.focusTIN,
                            textInputType: TextInputType.number,
                            onChanged: () => context.read<NewBloc>().add(ContractChange()),
                            onSubmitted: () => context.read<NewBloc>().add(ContractSubmitted(context: context)),
                            suffixIconDone: bloc.suffixTIN,
                            snackBarText: 'snack_tin'.tr(),
                            isMoney: false,
                          ),

                          // #status_of_the_contract

                          MyDropdownButton(
                            titleText: 'status_contract'.tr(),
                            focusNode: bloc.focusStatus,
                            status: bloc.status,
                            statusList: bloc.statusList,
                            onChanged: (status) => context.read<NewBloc>().add(ContractStatus(status: status)),
                          ),
                          const SizedBox(height: 10),

                          MyButton(
                            text: 'save_contract'.tr(),
                            function: () => context.read<NewBloc>().add(ContractSave()),
                            enable: bloc.suffixFullName && bloc.suffixAddress && bloc.suffixTIN
                                && bloc.face != null && bloc.status != null,
                          )
                        ],
                      ),
                  ),
        );
      }),
    );
  }
}