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
        child: _StreamScreen()
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
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
            onPressed: () { context.read<MyStreamingCubit>().startStream(); },
          child: const Text("Go Live")
        ),
      ),
    );
  }
}
//
//










