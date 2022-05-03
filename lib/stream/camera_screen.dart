import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kstream/widgets/widgets.dart';

import 'package:kstream/repository/repository.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:unicons/unicons.dart';

import 'bloc/cubit.dart';



class StreamScreen extends StatelessWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MyStreamingCubit>(
            create: (BuildContext context) => MyStreamingCubit(
              context.read<Repository>(),
            ),
          )
        ],
        child: const _StreamScreen()
    );
  }
}




class _StreamScreen extends StatelessWidget {
  const _StreamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        ),
      child:BlocBuilder<MyStreamingCubit, MyStreamingState>(
        builder: (context, state) {

          if (state.fatalError.isNotEmpty) {
            return FatalErrorWidget(state.fatalError);
          }

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              alignment: Alignment.topCenter,
              children:  [

                Container(color: Colors.black,),



                if (state.initialized)
                  Center(
                    child: FlutterRtmpCameraPreview(controller: context.read<MyStreamingCubit>().streamer),
                  ),



                const BottomGradient(),

                Positioned(
                    top: 50,
                    right: 10,
                    child: StreamingStatusWidget(connectState: state.connectState)
                ),

                LiveButton(enabled: state.showLiveButton,),
              ],
            )
          );
        }
      )
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
        child: Center(child: Text(error, textAlign: TextAlign.center,),),
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


class BottomGradient extends StatelessWidget {
  const BottomGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 100;

    final orientation = MediaQuery.of(context).orientation;

    final Alignment begin = orientation == Orientation.portrait
        ? Alignment.topCenter
        : Alignment.centerLeft;

    final Alignment end = orientation == Orientation.portrait
        ? Alignment.bottomCenter
        : Alignment.centerRight;

    return Container(
      height: orientation == Orientation.portrait ? size : null,
      width: orientation == Orientation.landscape ? size : null,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: const [ Color.fromRGBO(0, 0, 0, 0), Color.fromRGBO(0, 0, 0, 0.6)]
          )
      ),
    );
  }
}



class LiveButton extends StatelessWidget {

  static const liveButtonAnimationDuration = Duration(milliseconds: 350);
  final bool enabled;


  const LiveButton({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final double finalPosition = enabled ? 100 : -100;

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
//
//










