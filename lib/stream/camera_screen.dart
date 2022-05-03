import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kstream/widgets/widgets.dart';

import 'package:kstream/repository/repository.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';

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

                LiveButton(enabled: state.showLiveButton,),

                // Text("aaa"),
                // Loader(),
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
            onPressed: () { context.read<MyStreamingCubit>().startStream(); },
          child: const Text("Go Live")
        ),
      ),
    );
  }
}
//
//










