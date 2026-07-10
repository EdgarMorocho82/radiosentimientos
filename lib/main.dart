import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/models/admob_models.dart';
import 'package:radioxr/models/player_models.dart';
import 'package:radioxr/screens/about_screens.dart';
import 'package:radioxr/screens/player_screens.dart';
import 'package:radioxr/screens/sleeptimer_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await AdmobService.init();

  final providers = [
    ChangeNotifierProvider<PlayerScreenModel>(
      create: (_) => PlayerScreenModel(),
    ),
    ChangeNotifierProxyProvider<PlayerScreenModel, TimerProvider>(
      create: (_) => TimerProvider(),
      update: (context, playerViewModel, timerViewModel) =>
          timerViewModel!..onTimer = playerViewModel.pause,
    ),
  ];

  final routes = {
    PlayerScreen.routeName: (_) => const PlayerScreen(),
    AboutView.routeName: (_) => const AboutView(),
    TimerView.routeName: (_) => const TimerView(),
  };

  runApp(App(providers: providers, routes: routes));
}

class App extends StatelessWidget {
  const App({super.key, required this.providers, required this.routes});

  final Map<String, Widget Function(dynamic)> routes;
  final List<SingleChildStatelessWidget> providers;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Config.appNameScreen,
        theme: ThemeData(fontFamily: 'Poppins'),
        routes: routes,
      ),
    );
  }
}
