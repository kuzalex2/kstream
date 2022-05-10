
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/models/stream_endpoint.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';
import 'package:kstream/screens/settings/widgets.dart';

import 'edit_endpoint.dart';

class StreamingEndpointsWidget extends StatelessWidget {
  const StreamingEndpointsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 16),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(50, 159, 217, 0.16),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text("Streaming Endpoints:"),
            ),
            _EndpointsList(),
          ],
        ),
      ),
    );
  }
}


class _EndpointsList extends StatelessWidget {
  const _EndpointsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AddEndpointRow(disabled: state.streamingState.isStreaming),

            ...state.endpointsList.list.map((streamEndpoint) =>
              EndpointRow(streamEndpoint, disabled: state.streamingState.isStreaming,)).toList(),
          ],
        );
      }
    );
  }
}

class AddEndpointRow extends StatelessWidget {
  const AddEndpointRow({Key? key, required this.disabled}) : super(key: key);
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RaisedButton(
        color: const Color.fromRGBO(252, 183, 19, 1),
        padding:const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),),
        onPressed: disabled ? null : () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const EditEndpointScreen(initialEndpointName: '', initialStreamingURL: '', initialStreamKey: '',)
              )
          );
        },
        child: const Text("ADD"),
      ),
    );
  }
}


class EndpointRow extends StatelessWidget {
  final StreamEndpoint endpoint;
  final bool disabled;
  const EndpointRow(this.endpoint,{Key? key, required this.disabled}) : super(key: key);


  Future showConfirmationDialog(BuildContext context) => showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(
              brightness: Brightness.light,
          ),
          child: CupertinoAlertDialog(
            title: const Text("Delete this endpoint?"),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
                isDefaultAction: true,
              ),
              CupertinoDialogAction(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                isDefaultAction: false,
              ),
            ],
          ),
        );
      });


  @override
  Widget build(BuildContext context) {

    final child = SettingsSwitch(title: "${endpoint.name}", disabled: disabled, value: endpoint.active, onChanged: (value) {
      if (value){
        context.read<SettingsCubit>().setActiveEndpoint(endpoint);
      } else {
        context.read<SettingsCubit>().setActiveEndpoint(null);
      }
    });

    if (disabled) {
      return child;
    }

    return Dismissible(

      key: ValueKey(endpoint),

      onDismissed: (direction) {
        context.read<SettingsCubit>().deleteEndpoint(endpoint);
      },

      confirmDismiss: (DismissDirection dismissDirection) async {
        switch(dismissDirection) {

          case DismissDirection.endToStart:
            return await showConfirmationDialog(context);
          case DismissDirection.startToEnd:
          case DismissDirection.horizontal:
          case DismissDirection.vertical:
          case DismissDirection.up:
          case DismissDirection.down:
        }
        return false;
      },

      background: Container(color: const Color.fromRGBO(50, 159, 217, 0.16)),
      secondaryBackground: Container(color: Colors.red),



      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => EditEndpointScreen(
                    initialEndpointName: endpoint.name,
                    initialStreamingURL: endpoint.url,
                    initialStreamKey: endpoint.key,
                  )
              )
          );
        },
        child: child
      ),
    );
  }
}




