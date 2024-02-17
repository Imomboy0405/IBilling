part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class EditProfileEvent extends ProfileEvent {
  final BuildContext context;

  EditProfileEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class NotificationEvent extends ProfileEvent {
  final BuildContext context;

  NotificationEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SecurityEvent extends ProfileEvent {
  final BuildContext context;

  SecurityEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AppearanceEvent extends ProfileEvent {
  final BuildContext context;

  AppearanceEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class HelpEvent extends ProfileEvent {
  final BuildContext context;

  HelpEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class LogoutEvent extends ProfileEvent {
  final BuildContext context;

  LogoutEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class InitialEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
