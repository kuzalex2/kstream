import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';

import '../../models/stream_endpoint.dart';

part 'endpoint_state.dart';
part '../../models/form_inputs.dart';


class EditEndpointCubit extends Cubit<EditEndpointState>  {

  final SettingsCubit settingsCubit;


  EditEndpointCubit({
    required this.settingsCubit,
    required StreamEndpoint initialEndpoint,
  }) : super(EditEndpointState.initial(initialEndpoint: initialEndpoint));



  void endpointNameChanged(String value) {
    final endpointNameInput = EndpointNameInput.dirty(value);
    emit(state.copyWith(
      endpointNameInput: endpointNameInput,
      status: Formz.validate([endpointNameInput, state.streamingURLInput, state.streamKeyInput]),
    ));
  }

  void streamingURLChanged(String value) {
    final streamingURLInput = StreamingURLInput.dirty(value);
    emit(state.copyWith(
      streamingURLInput: streamingURLInput,
      status: Formz.validate([state.endpointNameInput, streamingURLInput, state.streamKeyInput]),
    ));
  }

  void streamKeyChanged(String value) {
    final streamKeyInput = StreamKeyInput.dirty(value);
    emit(state.copyWith(
      streamKeyInput: streamKeyInput,
      status: Formz.validate([state.endpointNameInput, state.streamingURLInput, streamKeyInput]),
    ));
  }

  Future<void> save() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    await Future.delayed(const Duration(milliseconds: 1000));


    final newEndpoint = state.initialEndpoint.copyWith(
      name: state.endpointNameInput.value,
      url: state.streamingURLInput.value,
      key: state.streamKeyInput.value,
    );


    if (state.initialEndpoint.isEmpty){
      settingsCubit.addNewEndpoint(newEndpoint);
    } else {
      settingsCubit.updateEndpoint(state.initialEndpoint, newEndpoint);
    }

    emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }


}
