

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/repository/repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;


part 'state.dart';



class PermissionCubit extends Cubit<PermissionState> with  WidgetsBindingObserver {

  AppLifecycleState? _prevState;
  final Repository repository;

  PermissionCubit({required PermissionState permissionState, required this.repository}) : super(permissionState)
  {
    WidgetsBinding.instance?.addObserver(this);
    _init();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance?.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    /// we need to track the case when the user went to app settings, changed permissions and came back
    if (Platform.isAndroid){
      if (state == AppLifecycleState.resumed && _prevState!=null && _prevState == AppLifecycleState.paused) {
        _init();
      }

      _prevState = state;
    }
  }

  _init() async {

    emit(state.copyWith(
      micStatus: MyPermissionStatus.unknown,
      camStatus: MyPermissionStatus.unknown,
    ));


    await Future.delayed(const Duration(milliseconds: 400));


    if (repository.sharedPreferences.isMicPermissionKnown) {
      Permission.microphone.status.then((value) {
        emit(state.copyWith(
            micStatus: MyPermissionStatusGetters.create(value)));
        repository.sharedPreferences.isMicPermissionKnown = true;
      });
    } else {
      emit(state.copyWith(micStatus: MyPermissionStatus.undetermined));
    }

    if (repository.sharedPreferences.isCamPermissionKnown) {
      Permission.camera.status.then((value) {
        emit(state.copyWith(
            camStatus: MyPermissionStatusGetters.create(value)));
        repository.sharedPreferences.isCamPermissionKnown = true;
      });
    } else {
      emit(state.copyWith(camStatus: MyPermissionStatus.undetermined));
    }
  }

  Future<void> requestCamPermission() async {

    if (state.camStatus.isUndetermined) {
      final value = await Permission.camera.request();

      repository.sharedPreferences.isCamPermissionKnown=true;
      emit(state.copyWith(camStatus: MyPermissionStatusGetters.create(value)));
    }

  }

  Future<void> requestMicPermission() async {
    if (state.micStatus.isUndetermined) {
      final value = await Permission.microphone.request();

      repository.sharedPreferences.isMicPermissionKnown=true;
      emit(state.copyWith(micStatus: MyPermissionStatusGetters.create(value)));
    }
  }

}
