
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/bloc/endpoint/endpoint_cubit.dart';

import 'package:formz/formz.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';

import 'package:kstream/models/stream_endpoint.dart';

class EditEndpointScreen extends StatelessWidget {
  final StreamEndpoint endpoint;


  const EditEndpointScreen({
    Key? key,
    required this.endpoint,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => EditEndpointCubit(
          settingsCubit: context.read<SettingsCubit>(),
          initialEndpoint: endpoint,
        ),
      child:const _EditEndpointScreen()
    );
  }
}


class _EditEndpointScreen extends StatelessWidget {

  const _EditEndpointScreen({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Drawer(
        child: Scaffold(
          appBar: const _AppBar(),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [


                SizedBox(height: 15,),
                Text("Endpoint Name:"),
                _EndpointNameInput(),

                SizedBox(height: 15,),
                Text("Streaming URL:"),
                _StreamingURLInput(),


                SizedBox(height: 15,),
                Text("Stream Key:"),
                _StreamKeyInput(),

              ],
            ),
          ),
        ),
      );
    }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return BlocConsumer<EditEndpointCubit, EditEndpointState>(

      listener: (context, state) {
        if (state.status.isSubmissionSuccess){
          Navigator.of(context).pop();
        }
      },

      builder: (context, state) {
        final canSave = state.hasChanges &&
            state.status.isValidated &&
            !state.status.isSubmissionInProgress;
        return AppBar(
          title: const Text("Edit Endpoint"),
          actions: [
            CupertinoButton(
              padding: const EdgeInsets.only(top: 0, right: 20),
              minSize: 0,
              onPressed: canSave ? () {
                context.read<EditEndpointCubit>().save();
              } : null,

              child: state.status.isSubmissionInProgress ? const _SavingProgress():
                  Text("Save", style: canSave ? const TextStyle(color: Colors.blueAccent) : null,)
            )
          ],
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _SavingProgress extends StatelessWidget {
  const _SavingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),)
    );
  }
}





class _EndpointNameInput extends StatelessWidget {

  const _EndpointNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EditEndpointCubit, EditEndpointState>(
      buildWhen: (previous, current) =>
          previous.endpointNameInput != current.endpointNameInput ||
          previous.status != current.status,

      builder: (context, state) {
        return TextFormField(

          initialValue: state.endpointNameInput.value,
          textCapitalization: TextCapitalization.words,
          keyboardAppearance: Brightness.light,
          onChanged: (value) =>
              context.read<EditEndpointCubit>().endpointNameChanged(value),
          readOnly: state.status.isSubmissionInProgress,
          autofocus: false,
          decoration: InputDecoration(
            suffixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 24
            ),
            errorText: state.endpointNameInput.invalid ? "invalid": null,
            hintText: "My youtube channel",
          ),
        );
      },
    );
  }
}


class _StreamingURLInput extends StatelessWidget {

  const _StreamingURLInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EditEndpointCubit, EditEndpointState>(
      buildWhen: (previous, current) =>
      previous.streamingURLInput != current.streamingURLInput ||
          previous.status != current.status,

      builder: (context, state) {
        return TextFormField(

          initialValue: state.streamingURLInput.value,
          keyboardAppearance: Brightness.light,
          onChanged: (value) =>
              context.read<EditEndpointCubit>().streamingURLChanged(value),
          readOnly: state.status.isSubmissionInProgress,
          autofocus: false,
          decoration: InputDecoration(
            suffixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 24
            ),
            errorText: state.streamingURLInput.invalid ? "invalid": null,
            hintText: "rtmp://a.rtmp.youtube.com/live2",
          ),
        );
      },
    );
  }
}


class _StreamKeyInput extends StatelessWidget {

  const _StreamKeyInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EditEndpointCubit, EditEndpointState>(
      buildWhen: (previous, current) =>
      previous.streamKeyInput != current.streamKeyInput ||
          previous.status != current.status,

      builder: (context, state) {
        return TextFormField(

          initialValue: state.streamKeyInput.value,
          keyboardAppearance: Brightness.light,
          onChanged: (value) =>
              context.read<EditEndpointCubit>().streamKeyChanged(value),
          readOnly: state.status.isSubmissionInProgress,
          autofocus: false,
          decoration: InputDecoration(
            suffixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 24
            ),
            errorText: state.streamKeyInput.invalid ? "invalid": null,

          ),
        );
      },
    );
  }
}





