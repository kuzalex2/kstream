
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/models/stream_endpoint.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';
import 'package:kstream/screens/settings/widgets.dart';

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
            Text("Streaming Endpoints:"),
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

          children: state.endpointsList.list.map((streamEndpoint) =>
              EndpointRow(streamEndpoint)).toList(),
        );
      }
    );
  }
}


class EndpointRow extends StatelessWidget {
  final StreamEndpoint endpoint;
  const EndpointRow(this.endpoint,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: SettingsSwitch(title: "${endpoint.name}", disabled: false, value: endpoint.active, onChanged: (value) {
        if (value){
          context.read<SettingsCubit>().setActiveEndpoint(endpoint);
        } else {
          context.read<SettingsCubit>().setActiveEndpoint(null);
        }
      })
      // child: Text("${endpoint.name}"),
    );
  }
}




