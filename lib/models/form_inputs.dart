
part of '../bloc/endpoint/endpoint_cubit.dart';


///
/// 
/// 

enum EndpointNameInputValidationError { invalid }

class EndpointNameInput extends FormzInput<String, EndpointNameInputValidationError> {
  const EndpointNameInput.pure([String value = '']) : super.pure(value);
  const EndpointNameInput.dirty([String value = '']) : super.dirty(value);

  static final RegExp _regExp =RegExp(r'^.{1,}$');

  @override
  EndpointNameInputValidationError? validator(String? value) {
    return _regExp.hasMatch(value ?? '')
        ? null
        : EndpointNameInputValidationError.invalid;
  }
}

///
/// 
///
enum StreamingURLInputValidationError { invalid }

class StreamingURLInput extends FormzInput<String, StreamingURLInputValidationError> {
  const StreamingURLInput.pure([String value = '']) : super.pure(value);
  const StreamingURLInput.dirty([String value = '']) : super.dirty(value);

  static final RegExp _regExp =RegExp(r'rtmps?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

  @override
  StreamingURLInputValidationError? validator(String? value) {
    return _regExp.hasMatch(value ?? '')
        ? null
        : StreamingURLInputValidationError.invalid;
  }
}


///
/// 
///
enum StreamKeyInputValidationError { invalid }

class StreamKeyInput extends FormzInput<String, StreamKeyInputValidationError> {
  const StreamKeyInput.pure([String value = '']) : super.pure(value);
  const StreamKeyInput.dirty([String value = '']) : super.dirty(value);

  static final RegExp _regExp =RegExp(r'.*');

  @override
  StreamKeyInputValidationError? validator(String? value) {
    return _regExp.hasMatch(value ?? '')
        ? null
        : StreamKeyInputValidationError.invalid;
  }
}