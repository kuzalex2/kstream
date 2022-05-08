
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp/controller.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp/model.dart';
import 'package:kstream/settings/utils.dart';
import 'package:kstream/settings/widgets.dart';
import 'package:unicons/unicons.dart';

import '../repository/repository.dart';
import '../widgets/widgets.dart';
import 'bloc/cubit.dart';
import 'dart:io' show Platform;
import 'package:collection/collection.dart';



class CameraSettingsDrawer extends StatelessWidget {
  final FlutterRtmpStreamer streamer;

  const CameraSettingsDrawer({Key? key, required this.streamer}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider<SettingsCubit>(
      create: (BuildContext context) => SettingsCubit(
        repository: context.read<Repository>(),
        streamer: streamer,
      ),
      child: const CameraSettingsDrawerInternal()
    );
  }
}


class CameraSettingsDrawerInternal extends StatelessWidget {

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
  const CameraSettingsDrawerInternal({Key? key/*, required this.streamer*/})
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
              return ListView(
                children: [


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

                  const SettingsLine(text: "VIDEO"),
                  //

                  const VideoResolutionsOption(),

                  //
                  //
                  SelectListOption<int>(
                      title: "Bitrate",

                      options: videoBitrates,

                      isSelectedPredicate: (settings, item) => item == settings.videoBitrate,

                      onSelected: (item) => cubit.changeStreamingSettings(
                                state.streamingState.streamingSettings.copyWith(videoBitrate: item)
                      ),

                  ),

                  //
                  //
                  SelectListOption<StreamingCameraFacing>(
                    title: "Camera Facing",

                    options: cameraFacings,
                    isSelectedPredicate: (settings, item) => item == settings.cameraFacing,

                    onSelected: (item) => cubit.changeStreamingSettings(
                        state.streamingState.streamingSettings.copyWith(cameraFacing: item)
                    ),

                  ),



                  //
                  //
                  SelectListOption<int>(
                    title: "FPS",

                    options: videoFPSs,
                    isSelectedPredicate: (settings, item) => item == settings.videoFps,

                    onSelected: (item) => cubit.changeStreamingSettings(
                        state.streamingState.streamingSettings.copyWith(videoFps: item)
                    ),

                  ),


                  //
                  //
                  if (Platform.isIOS)
                    SelectListOption<String>(
                      title: "h264 Profile",

                      options: h264Profiles,

                      isSelectedPredicate: (settings, item) => item == settings.h264profile,

                      onSelected: (item) => cubit.changeStreamingSettings(
                          state.streamingState.streamingSettings.copyWith(h264profile: item)
                      ),

                    ),

                  //
                  //
                  if (Platform.isIOS)
                    SelectListOption<String>(
                      title: "Stabilization Mode",

                      options: videoStabilizationModes,

                      isSelectedPredicate: (settings, item) => item == settings.stabilizationMode,

                      onSelected: (item) => cubit.changeStreamingSettings(
                          state.streamingState.streamingSettings.copyWith(stabilizationMode: item)
                      ),

                    ),


                  const SettingsLine(text: "AUDIO"),

                  //
                  //
                  SelectListOption<int>(
                    title: "Audio Bitrate",

                    options: audioBitrates,

                    isSelectedPredicate: (settings, item) => item == settings.audioBitrate,


                    onSelected: (item) => cubit.changeStreamingSettings(
                        state.streamingState.streamingSettings.copyWith(audioBitrate: item)
                    ),

                  ),

                  //
                  //
                  SelectListOption<int>(
                    title: "Sample Rate",

                    options: audioSampleRates,

                    isSelectedPredicate: (settings, item) => item == settings.audioSampleRate,

                    onSelected: (item) =>  cubit.changeStreamingSettings(
                        state.streamingState.streamingSettings.copyWith(audioSampleRate: item)
                    ),

                  ),

                  //
                  //
                  SelectListOption<int>(
                    title: "Channels Count",

                    options: audioChannelsCounts,

                    isSelectedPredicate: (settings, item) => item == settings.audioChannelCount,

                    onSelected: (item) => cubit.changeStreamingSettings(
                        state.streamingState.streamingSettings.copyWith(audioChannelCount: item)
                    ),

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
          onTap: () async {
              final result = await Navigator.of(context).push<Resolution>(
                  MaterialPageRoute(
                      builder: (_) => FutureListDrawer<Resolution>(
                        settingsCubit: context.read<SettingsCubit>(),
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
                        // onSelected: (item) =>
                        //     context.read<SettingsCubit>().changeStreamingSettings(
                        //         state.streamingState.streamingSettings.copyWith(resolution: item)
                        //     ),
                      )
                  )
              );
              if (result!=null){
                context.read<SettingsCubit>().changeStreamingSettings(
                    state.streamingState.streamingSettings.copyWith(resolution: result)
                );
              }
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
  final void Function(T) onSelected;
  final String title;



  const SelectListOption({
    Key? key,
    required this.title,
    required this.options,
    required this.isSelectedPredicate,
    required this.onSelected,
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
              final result = await Navigator.of(context).push<NamedValue<T>>(
                    MaterialPageRoute(
                        builder: (_) => ListDrawer<NamedValue<T>>(
                          settingsCubit: context.read<SettingsCubit>(),
                          title: title,
                          list: options,
                          selectedItem: selected,
                          // onSelected: onSelected,
                        )
                    )
                );
              if (result!=null){
                onSelected(result.value);
              }
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
class ListDrawer<T> extends StatelessWidget {

  const ListDrawer({
    Key? key,
    required this.title,
    required this.list,
    this.selectedItem,
    // this.onSelected,
    this.checkIsStreaming = true,
    required this.settingsCubit,
  }) : super(key: key);

  final String title;
  final List<T> list;
  final T? selectedItem;
  // final Function(T)? onSelected;
  final bool checkIsStreaming;
  final SettingsCubit settingsCubit;

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: Text(title),),
        body: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,

          child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return ListView(
                  children: list.map((item) =>
                      InkWell(
                        onTap: state.streamingState.inSettings || (checkIsStreaming && state.streamingState.isStreaming) ? null : () {
                          Navigator.of(context).pop(item);
                          // if (onSelected!=null) {
                          //   onSelected!(item);
                          // }
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
      ),
    );
  }
}

class FutureListDrawer<T> extends StatelessWidget {
  const FutureListDrawer({
    Key? key,
    required this.settingsCubit,
    required this.title,
    this.selectedItem,
    // this.onSelected,
    required this.futureList,
  }) : super(key: key);

  final SettingsCubit settingsCubit;
  final String title;
  final Future<List<T>> futureList;
  final T? selectedItem;
  // final Function(T)? onSelected;


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
            settingsCubit: settingsCubit,
            title: title,
            list: snapshot.data!,
            selectedItem: selectedItem,
            // onSelected: onSelected,
          );
        }
    );
  }
}



