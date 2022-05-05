
part of 'widgets.dart';


class AppToast {
  static show(BuildContext context, {
    required Widget child,
  }) {
    final uuid = const Uuid().v4();

    Navigator.push(
      context,
      PageRouteBuilder(
          settings: RouteSettings(name: _AppToastWidget.route,arguments: uuid),
          pageBuilder: (context, _, __) => _AppToastWidget(child: child, uuid: uuid,),
          opaque: false,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, -0.5);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.ease));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }
      ),
    );
  }
}

class _AppToastWidget extends StatefulWidget {
  final Widget child;

  final String uuid;

  const _AppToastWidget({
    required this.child,
    required this.uuid,
  });

  static const route = "/AppToast";


  @override
  State<StatefulWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget> {
  static const liveTimeout = Duration(seconds: 4);

  double _toastPosition = 0;
  double _startToastPosition = 0;

  Timer? _liveTimer;

  @override
  void initState() {
    _liveTimer = Timer(liveTimeout, () => _close());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _startToastPosition = MediaQuery.of(context).padding.top + 8;
    _toastPosition = _startToastPosition;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          top: _toastPosition,
          left: 16,
          right: 16,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: _close,
            onVerticalDragUpdate: _verticalDragUpdate,
            onVerticalDragEnd: _verticalDragEnd,
            child: widget.child
          ),
        ),
      ],
    );
  }

  _verticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _toastPosition += details.delta.dy;
      if (_toastPosition < _startToastPosition - 8) {
        _close();
      }
    });
  }

  _verticalDragEnd(DragEndDetails details) {
    setState(() {
      _toastPosition = _startToastPosition;
    });
  }

  _close() {

    bool isCurrent = false;
    Navigator.popUntil(context, (route) {

      if (route.settings.name == _AppToastWidget.route && route.settings.arguments == widget.uuid) {
        isCurrent = true;
      }

      return true;
    });

    if (isCurrent){
      Navigator.pop(context);
    } else {
      _liveTimer?.cancel();
      _liveTimer = Timer(liveTimeout~/10, () => _close());
    }
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }
}