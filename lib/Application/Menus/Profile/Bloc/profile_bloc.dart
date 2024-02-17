import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileInitialState()) {
    on<InitialEvent>(initialState);
    on<EditProfileEvent>(pressEditProfile);
    on<NotificationEvent>(pressNotification);
    on<SecurityEvent>(pressSecurity);
    on<AppearanceEvent>(pressAppearance);
    on<HelpEvent>(pressHelp);
    on<LogoutEvent>(pressLogout);
  }

  Future<void> initialState(InitialEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileInitialState());
  }

  Future<void> pressEditProfile(EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileEditProfileState());
  }

  Future<void> pressNotification(NotificationEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileNotificationState());
  }

  Future<void> pressSecurity(SecurityEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileSecurityState());
  }

  Future<void> pressAppearance(AppearanceEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileAppearanceState());
  }

  Future<void> pressHelp(HelpEvent event, Emitter<ProfileState> emit) async {
    // todo code
  }

  Future<void> pressLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(LogoutState());
  }
}
