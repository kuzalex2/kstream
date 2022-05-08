
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp/controller.dart';
import 'package:kstream/settings/utils.dart';
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
                  // VideoResolutionsOption(),
                  //
                  //
                  const VideoBitrateOption(),
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

///
///
///
// class VideoResolutionsOption extends StatelessWidget {
//
//   const VideoResolutionsOption({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SettingsCubit, SettingsState>(
//         builder: (context, state) {
//         return SettingsOption(
//           text: "Resolution",
//           rightText: "${state.streamingState.streamingSettings.resolution}",
//           onTap: () =>
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => FutureListDrawer<Resolution>(
//                         streamer: streamer,
//                         title: "Bitrate:",
//                         futureList: () async {
//                           final result = await streamer.getResolutions();
//                           // await Future.delayed(Duration(seconds: 1));
//                           // throw "some error";
//                           return result.front;
//                         }(),
//                         selectedItem: streamer.state.streamingSettings.resolution,
//                         onSelected: (item) =>
//                             streamer.changeStreamingSettings(
//                                 streamer.state.streamingSettings.copyWith(resolution: item)
//                             ),
//                       )
//                   )
//               ),
//           disabled: state.streamingState.inSettings || state.streamingState.isStreaming,
//         );
//       }
//     );
//   }
// }


///
///
///
class VideoBitrateOption extends StatelessWidget {


  const VideoBitrateOption({Key? key}) : super(key: key);

  static const List<NamedValue<int>> bitrates = [
    // NamedValue(-1, "Auto"),
    NamedValue(1 * 1024  * 1024,"1 Mbit/s"), // 360p
    NamedValue(2 * 1024 * 1024, "2 Mbit/s"), // 480p
    NamedValue(5 * 1024 * 1024, "5 Mbit/s"), // 720p
    NamedValue(8 * 1024 * 1024, "8 Mbit/s"), // 1080p
  ];

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {

        final selected = bitrates
            .firstWhere((b) => b.value == state.streamingState.streamingSettings.videoBitrate, orElse: () => const NamedValue(0, ""));

        final blocContext = context.read<SettingsCubit>();
        return SettingsOption(
          text: "Bitrate",
          rightText: selected.name,
          onTap: () =>
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => ListDrawer<NamedValue<int>>(
                        blocContext: blocContext,
                        title: "Bitrate:",
                        list: bitrates,
                        selectedItem: selected,
                        onSelected: (item) =>
                            blocContext.changeStreamingSettings(
                                state.streamingState.streamingSettings.copyWith(videoBitrate: item.value)
                            ),

                      )
                  )
              ),
          disabled: state.streamingState.inSettings || state.streamingState.isStreaming,
        );
      }
    );
  }

}



///
///
///
class ListDrawer<T> extends StatelessWidget {

  const ListDrawer({
    Key? key,
    required this.title,
    required this.list,
    this.selectedItem,
    this.onSelected,
    this.checkIsStreaming = true,
    required this.blocContext
  }) : super(key: key);

  final String title;
  final List<T> list;
  final T? selectedItem;
  final Function(T)? onSelected;
  final bool checkIsStreaming;
  final SettingsCubit blocContext;

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: Text(title),),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          bloc: blocContext,
            builder: (context, state) {
              return ListView(
                children: list.map((item) =>
                    InkWell(
                      onTap: state.streamingState.inSettings || (checkIsStreaming && state.streamingState.isStreaming) ? null : () {
                        Navigator.of(context).pop();
                        if (onSelected!=null) {
                          onSelected!(item);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: item == selectedItem ? ((checkIsStreaming && state.streamingState.isStreaming) ? Colors.grey : Colors.lightBlueAccent) : const Color.fromRGBO(0, 0, 0, 0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB (16,8,0,8),
                            child: Text(item.toString()),
                          )
                      ),
                    )
                ).toList(),
              );
            }
        ),
      ),
    );
  }
}
