import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/screens/settings/drawer.dart';

import 'package:kstream/widgets/widgets.dart';

import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:unicons/unicons.dart';

import 'package:kstream/bloc/streaming/streaming_cubit.dart';







class CameraScreen extends StatelessWidget {
  CameraScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future showAddEndpointDialog(BuildContext context) => showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: const Text("Would you like to add a streaming endpoint?"),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
              isDefaultAction: false,
            ),
            CupertinoDialogAction(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _scaffoldKey.currentState?.openDrawer();
              },
              isDefaultAction: true,
            ),
          ],
        );
      });


  @override
  Widget build(BuildContext context) {


    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        ),
      child: BlocListener<MyStreamingCubit, MyStreamingState>(

        ///
        listenWhen: (previous, current) => current.showOpenSettings && previous.showOpenSettings!=current.showOpenSettings,

        listener: (context, state){

          WidgetsBinding.instance!.addPostFrameCallback((_) => showAddEndpointDialog(context));
          context.read<MyStreamingCubit>().afterOpenSettingsHasBeenShown();
        },

        child: BlocConsumer<MyStreamingCubit, MyStreamingState>(

            ///
            listenWhen: (previous, current) => current.error.isNotEmpty && previous.error!=current.error,
            listener: (context, state){

              AppToast.show(context, child: ToastWidget(title: state.error,));
              context.read<MyStreamingCubit>().consumeError();
            },

            builder: (context, state) {

              if (state.fatalError.isNotEmpty) {
                return FatalErrorWidget(state.fatalError);
              }

              return Scaffold(
                key: _scaffoldKey,

                drawer: const CameraSettingsDrawer() ,
                body: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children:  [

                    Container(color: Colors.black,),

                    if (state.initialized)
                      Center(
                        child: AspectRatio(
                          aspectRatio: state.resolution.width == 0 ? 1.0 : 1.0 * state.resolution.height / state.resolution.width,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [

                              Container(
                                child: const FlutterRtmpCameraView(),
                              ),

                              const Positioned(
                                  top: 0,
                                  child: TopGradient(),
                              ),

                              const Positioned(
                                  bottom: 0,
                                  child: BottomGradient()
                              ),

                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: StreamingStatusWidget(connectState: state.connectState)
                              ),

                              Positioned(
                                  bottom: 0,
                                  child: Row(children: [


                                    StreamControlButton(
                                      iconData: state.audioMuted ? UniconsLine.microphone_slash : UniconsLine.microphone,
                                      enabled: true,
                                      activeColor: state.audioMuted ? Colors.red : null,
                                      onPressed: () =>
                                        context.read<MyStreamingCubit>().switchMicrophone(),
                                    ),

                                    StreamControlButton(
                                      iconData: UniconsLine.sync_icon,
                                      enabled: true,
                                      onPressed: () => context.read<MyStreamingCubit>().switchCamera(),
                                    ),

                                    StreamControlButton(
                                      iconData: UniconsLine.setting,
                                      enabled: true,
                                      onPressed: () =>
                                      ///FIXME

                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (_) => CameraSettingsDrawer(),
                                          // )),

                                          _scaffoldKey.currentState?.openDrawer(),

                                    ),



                                  ],),
                              ),


                              LiveButton(enabled: state.showLiveButton, position: 50,),

                            ],
                          ),
                        )
                      ),
                  ],
                ),
              );
            }
          ),
      ),

    );
  }
}



class StreamControlButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onPressed;
  final bool enabled;
  final Color? activeColor;

  const StreamControlButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.enabled,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CupertinoButton(
      child: Icon(iconData, color: enabled ? (activeColor ?? Colors.white) : null,),
      onPressed: enabled ? onPressed : null,
    );
  }
}


class FatalErrorWidget extends StatelessWidget {
  final String error;
  const FatalErrorWidget(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(child: Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red),),),
      ),
    );
  }
}

class StreamingStatusWidget extends StatelessWidget {

  static const animationDuration = Duration(milliseconds: 500);


  final ConnectState connectState;
  const StreamingStatusWidget({Key? key, required this.connectState}) : super(key: key);

  Color get _backColor {
    switch (connectState){
      case ConnectState.no:
      case ConnectState.ready: return const Color.fromRGBO(0, 0, 0, 0.6);
      case ConnectState.connecting: return const Color.fromRGBO(252, 183, 19, 1);
      case ConnectState.onAir: return const Color.fromRGBO(127, 186, 66, 1);
    }
  }

  String get _text {
    switch (connectState){
      case ConnectState.no:
      case ConnectState.ready: return "✓ READY";
      case ConnectState.connecting: return "CONNECTING";
      case ConnectState.onAir: return "ON AIR";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: _backColor,
          ),
          duration: animationDuration,
          child: Padding(
            padding: const EdgeInsets.only(left:4.0, right: 4, top: 2, bottom: 2),
            child: Text(
              _text,
            ),
          ),
        ),


        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: (connectState == ConnectState.connecting || connectState == ConnectState.onAir) ? () {
            context.read<MyStreamingCubit>().stopStream();
          } : null,
          child: Visibility(
            visible: (connectState == ConnectState.connecting || connectState == ConnectState.onAir),
            child: const Icon(UniconsLine.multiply, color: Colors.white, size: 24,),
          ),
        )

      ],
    );
  }
}

class MyGradient extends StatelessWidget {

  const MyGradient({Key? key, required this.gradient, required this.size}) : super(key: key);
  final LinearGradient gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: orientation == Orientation.portrait ? size : height,
      width: orientation == Orientation.landscape ? size : width,
      // color: Colors.red,
      decoration: BoxDecoration(
          gradient: gradient
      ),
    );
  }
}


class TopGradient extends StatelessWidget {
  const TopGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MyGradient(
        size: 140,
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 0, 0, 0.32),
            Color.fromRGBO(0, 0, 0, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
    );
  }
}


class BottomGradient extends StatelessWidget {
  const BottomGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MyGradient(
        size: 140,
        gradient: LinearGradient(
          colors: [ Color.fromRGBO(0, 0, 0, 0), Color.fromRGBO(0, 0, 0, 0.6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
    );
  }
}



class LiveButton extends StatelessWidget {

  static const liveButtonAnimationDuration = Duration(milliseconds: 350);
  final bool enabled;
  final double position;


  const LiveButton({Key? key, required this.enabled, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final double finalPosition = enabled ? position : -100;

    return AnimatedPositioned(
      duration: liveButtonAnimationDuration,
      bottom: finalPosition,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0,
        duration: liveButtonAnimationDuration,
        curve: Curves.decelerate,
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              minimumSize: MaterialStateProperty.all(const Size(150,40)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
            onPressed: () {
              context.read<MyStreamingCubit>().startStream();
              },
          child: Text("Go Live", style: Theme.of(context).textTheme.bodyText2,)
        ),
      ),
    );
  }
}




class ToastWidget extends StatelessWidget {
  final String title;
  const ToastWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: Colors.black38,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.red),
        ),
      ],),
    );
  }
}







