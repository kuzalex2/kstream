
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp/model.dart';

import 'dart:io' show Platform;
import 'package:collection/collection.dart';
import 'package:kstream/screens/settings/widgets.dart';
import 'package:kstream/widgets/widgets.dart';

import 'endpoints.dart';
import 'utils.dart';

import 'package:kstream/bloc/settings/settings_cubit.dart';






class CameraSettingsDrawer extends StatelessWidget {

  static const videoBitrates = [
    NamedValue(1 * 1024  * 1024,"1 Mbit/s"), // 360p
    NamedValue(2 * 1024 * 1024, "2 Mbit/s"), // 480p
    NamedValue(5 * 1024 * 1024, "5 Mbit/s"), // 720p
    NamedValue(8 * 1024 * 1024, "8 Mbit/s"), // 1080p
  ];

  static const cameraFacings =  [
    NamedValue(StreamingCameraFacing.front, "front"),
    NamedValue(StreamingCameraFacing.back, "back"),
  ];

  static const videoFPSs =  [
    NamedValue(15, '15'),
    NamedValue(30, '30'),
    NamedValue(25, '25'),
  ];
  static const h264Profiles = [
    NamedValue("baseline", "Baseline"),
    NamedValue("main", "Main"),
    NamedValue("high", "High"),
  ];

  static const videoStabilizationModes = [
    NamedValue("off","Off"),
    NamedValue("standard","Standard"),
    NamedValue("cinematic","Cinematic"),
    NamedValue("auto","Auto"),
  ];

  static const audioBitrates = [
    NamedValue(-1, "Default"),
    NamedValue(96  * 1024, "96 Kb/s"),
    NamedValue(128 * 1024, "128 Kb/s"),
    NamedValue(160 * 1024, "160 Kb/s"),
    NamedValue(256 * 1024, "256 Kb/s"),
    NamedValue(320 * 1024, "320 Kb/s"),
  ];

  static const audioSampleRates = [
    NamedValue(-1, "Default"),
    NamedValue(48000, "48 KHz"),
    NamedValue(44100, "44.1 KHz"),
    NamedValue(32000, "32 KHz"),
    NamedValue(24000, "24 KHz"),
    NamedValue(22050, "22.05 KHz"),
  ];

  static const audioChannelsCounts = [
    // NamedValue(-1, "Default"),
    NamedValue(1, "Mono"),
    NamedValue(2, "Stereo"),
  ];

  // final FlutterRtmpStreamer streamer;
  const CameraSettingsDrawer({Key? key/*, required this.streamer*/})
      : super(key: key)
  ;



  @override
  Widget build(BuildContext context) {

    final cubit = context.read<SettingsCubit>();

    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: const Text("Settings:"),),

        body: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {

              if (state.streamingState.isEmpty) {
                return const Loader();
              }

              return ListView(
                children: [


                  const StreamingEndpointsWidget(),


                  const SettingsLine(text: "VIDEO"),
                  //

                  ///
                  ///
                  /// Background streaming

                  Visibility(
                    visible: Platform.isAndroid,
                    child: SettingsSwitch(
                      title: "Background streaming",
                      disabled: state.streamingState.isStreaming || state.streamingState.inSettings,
                      value: state.streamingState.streamingSettings.serviceInBackground,
                      onChanged: (bool value) => cubit.changeStreamingSettings(
                          state.streamingState.streamingSettings.copyWith(serviceInBackground: value)
                      ),
                    ),
                  ),

                  const VideoResolutionsOption(),

                  //
                  //
                  SelectListOption<int>(
                      title: "Bitrate",

                      options: videoBitrates,

                      isSelectedPredicate: (settings, item) => item == settings.videoBitrate,

                      onApply: (settings, newValue) => settings.copyWith(videoBitrate: newValue.value),

                  ),

                  //
                  //
                  SelectListOption<StreamingCameraFacing>(
                    title: "Camera Facing",

                    options: cameraFacings,
                    isSelectedPredicate: (settings, item) => item == settings.cameraFacing,

                    onApply: (settings, newValue) => settings.copyWith(cameraFacing: newValue.value),


                  ),



                  //
                  //
                  SelectListOption<int>(
                    title: "FPS",

                    options: videoFPSs,
                    isSelectedPredicate: (settings, item) => item == settings.videoFps,
                    onApply: (settings, newValue) => settings.copyWith(videoFps: newValue.value),



                  ),


                  //
                  //
                  if (Platform.isIOS)
                    SelectListOption<String>(
                      title: "h264 Profile",

                      options: h264Profiles,

                      isSelectedPredicate: (settings, item) => item == settings.h264profile,
                      onApply: (settings, newValue) => settings.copyWith(h264profile: newValue.value),


                    ),

                  //
                  //
                  if (Platform.isIOS)
                    SelectListOption<String>(
                      title: "Stabilization Mode",

                      options: videoStabilizationModes,

                      isSelectedPredicate: (settings, item) => item == settings.stabilizationMode,

                      onApply: (settings, newValue) => settings.copyWith(stabilizationMode: newValue.value),


                    ),


                  const SettingsLine(text: "AUDIO"),

                  //
                  //
                  SelectListOption<int>(
                    title: "Audio Bitrate",

                    options: audioBitrates,

                    isSelectedPredicate: (settings, item) => item == settings.audioBitrate,
                    onApply: (settings, newValue) => settings.copyWith(audioBitrate: newValue.value),




                  ),

                  //
                  //
                  SelectListOption<int>(
                    title: "Sample Rate",

                    options: audioSampleRates,

                    isSelectedPredicate: (settings, item) => item == settings.audioSampleRate,
                    onApply: (settings, newValue) => settings.copyWith(audioSampleRate: newValue.value),



                  ),

                  //
                  //
                  if (Platform.isAndroid)
                    SelectListOption<int>(
                      title: "Channels Count",

                      options: audioChannelsCounts,

                      isSelectedPredicate: (settings, item) => item == settings.audioChannelCount,

                      onApply: (settings, newValue) => settings.copyWith(audioChannelCount: newValue.value),


                    ),



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
class VideoResolutionsOption extends StatelessWidget {

  const VideoResolutionsOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
        return SettingsOption(
          title: "Resolution",
          rightTitle: "${state.streamingState.streamingSettings.resolution}",
          onTap: ()  {
              Navigator.of(context).push<Resolution>(
                  MaterialPageRoute(
                      builder: (_) => FutureListDrawer<Resolution>(
                        title: "Bitrate:",
                        futureList: () async {
                          final result = await context.read<SettingsCubit>().getResolutions();
                          return result.front;
                          // await Future.delayed(Duration(seconds: 1));
                          // throw "some error";
                          // return result.front;
                          // return <Resolution>[];
                        }(),
                        selectedItem: state.streamingState.streamingSettings.resolution,
                        onApply: (settings, newValue) => settings.copyWith(resolution: newValue),

                      )
                  )
              );

          },
          disabled: state.streamingState.inSettings || state.streamingState.isStreaming,
        );
      }
    );
  }
}


class SelectListOption<T> extends StatelessWidget {

  final List<NamedValue<T>> options;
  final Function(StreamingSettings, T) isSelectedPredicate;
  final ApplyCallback<NamedValue<T>> onApply;

  final String title;



  const SelectListOption({
    Key? key,
    required this.title,
    required this.options,
    required this.isSelectedPredicate,
    required this.onApply,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {



    return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {

          final selected = options.firstWhereOrNull(
                  (b) => isSelectedPredicate(state.streamingState.streamingSettings, b.value),
          );

          return SettingsOption(
            title: title,
            rightTitle: selected?.name ?? "",
            onTap: () async {
              Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ListDrawer<NamedValue<T>>(
                          title: title,
                          list: options,
                          onApply: onApply,
                          selectedItem: selected,
                          // onSelected: onSelected,
                        )
                    )
              );

            },
            disabled: state.streamingState.inSettings || state.streamingState.isStreaming,
          );
        }
    );
  }
}


///
///
///

typedef ApplyCallback<T> = StreamingSettings Function(StreamingSettings, T);

class ListDrawer<T> extends StatelessWidget {

  const ListDrawer({
    Key? key,
    required this.title,
    required this.list,
    this.selectedItem,
    required this.onApply,
    this.checkIsStreaming = true,
  }) : super(key: key);


  final String title;
  final List<T> list;
  final T? selectedItem;
  final ApplyCallback<T> onApply;
  final bool checkIsStreaming;

  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: Scaffold(
          appBar: AppBar(title: Text(title),),
          body: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {

                return ListView(
                  children: list.map((item) =>
                      InkWell(
                        onTap: state.streamingState.inSettings || (checkIsStreaming && state.streamingState.isStreaming) ? null : () {
                          Navigator.of(context).pop(item);

                          context.read<SettingsCubit>().changeStreamingSettings(
                              onApply(state.streamingState.streamingSettings, item)
                          );

                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: item == selectedItem ?
                              ((checkIsStreaming && state.streamingState.isStreaming) ? Colors.grey : Colors.lightBlueAccent) :
                              const Color.fromRGBO(0, 0, 0, 0),
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

class FutureListDrawer<T> extends StatelessWidget {
  const FutureListDrawer({
    Key? key,
    required this.title,
    this.selectedItem,
    required this.onApply,
    required this.futureList,
  }) : super(key: key);

  final String title;
  final Future<List<T>> futureList;
  final T? selectedItem;
  final ApplyCallback<T> onApply;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
        future: futureList,
        builder: (context, snapshot) {

          if (snapshot.hasError){
            return Drawer(
                child: Scaffold(
                    appBar: AppBar(title: Text(title),),
                    body: Center(
                        child: Text(snapshot.error.toString())
                    ),
                ));
          }

          if (!snapshot.hasData){
            return Drawer(
                child: Scaffold(
                    appBar: AppBar(title: Text(title),),
                    body: const Loader()
                ));
          }

          return ListDrawer<T>(
            title: title,
            onApply: onApply,
            list: snapshot.data!,
            selectedItem: selectedItem,
            // onSelected: onSelected,
          );
        }
    );
  }
}





