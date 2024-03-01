import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_billing/Application/Main/Bloc/main_bloc.dart';
import 'package:i_billing/Configuration/app_data_time.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/db_service.dart';
import 'package:i_billing/Data/Service/rtdb_service.dart';

part 'contracts_event.dart';
part 'contracts_state.dart';

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  final MainBloc mainBloc;
  bool initialDayFirst = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  List<String> monthNames = AppDateTime.monthNames;
  List<int> monthDays = AppDateTime.monthDays;

  ScrollController invoiceController = ScrollController();
  ScrollController dayController = ScrollController();
  ScrollController dayController2 = ScrollController();

  bool dayControllerLeftDone = true;
  bool dayControllerRightDone = true;

  ContractsBloc({required this.mainBloc}) : super(ContractsInitialState(day: DateTime.now().day, month: DateTime.now().month,)) {
    on<InitialDayControllerEvent> (initialDayButtonController);
    on<InitialDay2ControllerEvent> (initialDay2ButtonController);
    on<ListenEvent> (listerDayButtonsController);
    on<FilterEvent> (pressFilter);
    on<SearchEvent> (pressSearch);
    on<MonthButtonEvent> (pressMonthButton);
    on<DayButtonEvent> (pressDayButton);
    on<OnReorderEvent> (onReorder);
    on<GetInvoicesEvent> (getInvoices);
  }

  Future<void> initialDayButtonController (InitialDayControllerEvent event, Emitter<ContractsState> emit) async {
    if (initialDayFirst) {
      initialDayFirst = false;
      int currentMonthDayMax = AppDateTime.monthDays[DateTime.now().month - 1] == 28 && DateTime.now().year == 2024
          ? 29
          : AppDateTime.monthDays[DateTime.now().month - 1];

      double position = currentMonthDayMax - selectedDay < event.width ~/ 62
          ? ((currentMonthDayMax - (event.width ~/ 62)).toDouble()) * 62 - event.width % 62
          : (selectedDay.toDouble() - 1) * 62;
      dayController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void initialDay2ButtonController (InitialDay2ControllerEvent event, Emitter<ContractsState> emit) {
    dayController2.jumpTo(event.position);
  }

  Future <void> getInvoices(GetInvoicesEvent event, Emitter<ContractsState> emit) async {
    emit(ContractsLoadingState());

    String? json = await DBService.loadData(StorageKey.user);
    UserModel user = userFromJson(json!);
    mainBloc.invoices = await RTDBService.loadInvoices(user.uId!);

    emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
  }

  void pressFilter(FilterEvent event, Emitter<ContractsState> emit) {
    // todo code
  }

  void pressSearch(SearchEvent event, Emitter<ContractsState> emit) {
    // todo code
  }

  void pressMonthButton(MonthButtonEvent event, Emitter<ContractsState> emit) {
    if (event.left) {
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear--;
      } else {
        selectedMonth--;
      }
      selectedDay = monthDays[selectedMonth - 1] == 28 && selectedYear == 2024 ? 29 : monthDays[selectedMonth - 1];
      dayController.jumpTo(selectedDay * 62 - event.width);
    } else {
      if (selectedMonth == 12) {
        selectedMonth = 1;
        selectedYear++;
      } else {
        selectedMonth++;
      }
      selectedDay = 1;
      dayController.jumpTo(0);
    }
    mainBloc.selectedDay = selectedDay;
    mainBloc.selectedMonth = selectedMonth;
    mainBloc.selectedYear = selectedYear;
    mainBloc.dayControllerPixels = dayController.position.pixels;

    emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
  }

  void pressDayButton(DayButtonEvent event, Emitter<ContractsState> emit) {
    selectedDay = event.selectedDay;
    mainBloc.selectedDay = selectedDay;
    emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
  }

  void listerDayButtonsController(ListenEvent event, Emitter<ContractsState> emit) async {

    if (dayController.position.pixels >= 0) {
      dayControllerLeftDone = true;
    }
    if (dayController.position.pixels <= monthDays[selectedMonth - 1] * 62) {
      dayControllerRightDone = true;
    }

    if (dayController.position.pixels < -110 && dayControllerLeftDone) {
      dayControllerLeftDone = false;
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear--;
      } else {
        selectedMonth--;
      }
      selectedDay = monthDays[selectedMonth - 1] == 28 && selectedYear == 2024 ? 29 : monthDays[selectedMonth - 1];
      emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
      dayController.jumpTo((selectedDay) * 62 + 109 - event.width);
    }

    if (dayControllerRightDone && dayController.position.pixels >
        ((monthDays[selectedMonth - 1] == 28 && selectedYear == 2024)
        ? 29 * 62 + 110 - event.width
        : monthDays[selectedMonth - 1] * 62 + 110 - event.width)) {
      dayControllerRightDone = false;
      if (selectedMonth == 12) {
        selectedMonth = 1;
        selectedYear++;
      } else {
        selectedMonth++;
      }
      selectedDay = 1;
      emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
      dayController.jumpTo(-109);
    }
    mainBloc.selectedDay = selectedDay;
    mainBloc.selectedMonth = selectedMonth;
    mainBloc.selectedYear = selectedYear;
    mainBloc.dayControllerPixels = dayController.position.pixels;
  }

  void onReorder(OnReorderEvent event, Emitter<ContractsState> emit) {
    final newIdx = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    final item = mainBloc.invoices.removeAt(event.oldIndex);
    mainBloc.invoices.insert(newIdx, item);

    emit(ContractsInitialState(month: selectedMonth, day: selectedDay));
  }
}
