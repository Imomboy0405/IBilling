part of 'main_bloc.dart';

@immutable
abstract class MainState extends Equatable {}

class MainInitialState extends MainState {
  final int screen;

  MainInitialState(this.screen);
  @override
  List<Object?> get props => [screen];
}