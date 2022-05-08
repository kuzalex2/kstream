
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp/controller.dart';
import 'package:kstream/settings/widgets.dart';
import 'package:unicons/unicons.dart';

import '../repository/repository.dart';
import 'bloc/cubit.dart';
import 'dart:io' show Platform;



class CameraSettingsDrawer extends StatelessWidget {
  final FlutterRtmpStreamer streamer;

  const CameraSettingsDrawer({Key? key, required this.streamer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(
              repository: context.read<Repository>(),
              streamer: streamer,
            ),
          )
        ],
        child: const CameraSettingsDrawerInternal()
    );
  }
}


class CameraSettingsDrawerInternal extends StatelessWidget {

  // final FlutterRtmpStreamer streamer;
  const CameraSettingsDrawerInternal({Key? key/*, required this.streamer*/})
      : super(key: key)
  ;



  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: const Text("Settings:"),),

        body: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return ListView(
                children: [


                  ///
                  ///
                  /// Background streaming

                  Visibility(
                    visible: Platform.isAndroid,
                    child: SettingsSwitch(
                      iconData: UniconsLine.wifi_router,
                      title: "Background streaming",
                      disabled: state.streamingState.isStreaming || state.streamingState.inSettings,
                      value: state.streamingState.streamingSettings.serviceInBackground,
                      onChanged: (bool value) => context.read<SettingsCubit>().changeStreamingSettings(
                          state.streamingState.streamingSettings.copyWith(serviceInBackground: value)
                      ),
                    ),
                  ),

                  // const SettingsLine(text: "VIDEO"),
                  //
                  // VideoResolutionsOption(streamer, streamingState),
                  //
                  //
                  // VideoBitrateOption(streamer, streamingState),
                  //
                  //
                  // CameraFacingOption(streamer, streamingState),
                  //
                  //
                  // VideoFPSOption(streamer, streamingState),
                  //
                  //
                  // Visibility(
                  //     visible: Platform.isIOS,
                  //     child: H264ProfileOption(streamer, streamingState)
                  // ),
                  //
                  //
                  //
                  // Visibility(
                  //     visible: Platform.isIOS,
                  //     child: VideoStabilizationModeOption(streamer, streamingState)
                  // ),
                  //
                  //
                  //
                  //
                  // const SettingsLine(text: "AUDIO"),
                  //
                  // AudioBitrateOption(streamer, streamingState),
                  //
                  //
                  // AudioSampleRateOption(streamer, streamingState),
                  //
                  //
                  // AudioChannelsOption(streamer, streamingState),

                ],
              );
            }
        ),
      ),
    );
  }


}
