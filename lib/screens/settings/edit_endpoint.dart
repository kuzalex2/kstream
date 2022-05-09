
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/models/stream_endpoint.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';
import 'package:kstream/screens/settings/widgets.dart';

class EditEndpointScreen extends StatelessWidget {

  const EditEndpointScreen({
    Key? key,

  }) : super(key: key);


 ///ontext.read<SettingsCubit>().changeStreamingSettings(
  //                               onApply(state.streamingState.streamingSettings, item)
  //                           );

  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: Scaffold(
          appBar: AppBar(title: const Text("Edit Endpoint"),),
          body: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {

                return Container();
              }
          ),
        ),
      );



}

