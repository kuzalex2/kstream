import 'package:flutter/material.dart';
import 'package:kstream/screens/camera_screen.dart';

import 'package:kstream/widgets/widgets.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstream/screens/permissions/permission_screen.dart';
import 'package:kstream/repository/repository.dart';

import 'bloc_observer.dart';

import 'package:kstream/bloc/permission/permission_cubit.dart';
import 'package:kstream/bloc/settings/settings_cubit.dart';
import 'package:kstream/bloc/streaming/streaming_cubit.dart';




const bool isProduction = bool.fromEnvironment('dart.vm.product');


Future<void> main() async {
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  final repository = Repository();
  await repository.init();


  runApp(App(repository: repository));
}

class App extends StatelessWidget {
  const App({Key? key, required this.repository}):super(key: key);

  final Repository repository;

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider.value(
        value: repository,
        child: const MyApp()
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PermissionCubit>(
            create: (BuildContext context) => PermissionCubit(
              permissionState: PermissionState.unknown,
              repository: context.read<Repository>(),
            ),
          ),

          BlocProvider<MyStreamingCubit>(
            create: (BuildContext context) => MyStreamingCubit(
              repository: context.read<Repository>(),
            ),
          ),

          BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(
              repository: context.read<Repository>(),
            ),
          ),

        ],
        child: MaterialApp(

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: const TextTheme(
              bodyText1: TextStyle(fontSize: 16.0),
              bodyText2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                letterSpacing: 1.02,
              ),
            ),
          ),
          themeMode: ThemeMode.dark,

          home: const AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: MainScreen()
          ),
        )
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PermissionCubit, PermissionState>(
          builder: (context, state) {

            if (state.micStatus.isUnknown || state.camStatus.isUnknown) {
              return const Loader();
            }

            if (state.micStatus.isGranted && state.camStatus.isGranted){
              return CameraScreen();
            }

            return PermissionsScreen(permissionState: state,);
          }
      ),

    );
  }
}
