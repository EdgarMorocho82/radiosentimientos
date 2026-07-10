import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:provider/provider.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/constants/language.dart';
import 'package:radioxr/constants/theme.dart';
import 'package:radioxr/models/admob_models.dart';
import 'package:radioxr/models/player_models.dart';
import 'package:radioxr/screens/sleeptimer_screens.dart';
import 'package:radioxr/widgets/sidebar.dart';
import 'package:radioxr/widgets/social.dart';
import 'package:radioxr/widgets/textscrool.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});
  static const routeName = '/';

  @override
  PlayerScreenState createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {
  late final viewModel = Provider.of<PlayerScreenModel>(context, listen: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double get padding => MediaQuery.of(context).size.width * 0.08;
  final ValueNotifier<bool> isPlaying = ValueNotifier(true);
  bool _handlingBack = false;
  get svgFileName => null;

  Future<void> _showExitDialog(
    BuildContext context,
    PlayerScreenModel viewModel,
  ) async {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
      return;
    }
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Language.title),
        content: const Text(Language.content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Language.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 50));
              await AppMinimizer.minimizeApp();
            },
            child: const Text(Language.minimize),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await viewModel.stop();
              SystemNavigator.pop();
            },
            child: const Text(Language.exit),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlayerScreenModel>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (_handlingBack) return;

        _handlingBack = true;
        try {
          await _showExitDialog(context, context.read<PlayerScreenModel>());
        } finally {
          _handlingBack = false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.bars,
                  size: 35.0,
                  color: AppTheme.iconSideBar,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.boxIconSleepTimer,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.boxIconSleepTimer,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.alarm,
                  size: 35.0,
                  color: AppTheme.iconSleepTimer,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerView()),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        drawer: NavDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      const Spacer(flex: 2),
                      _buildStreamCover(),
                      const Spacer(flex: 1),
                      Visibility(
                        visible: Config.visualizer,
                        child: AnimatedOpacity(
                          opacity: viewModel.isPlaying ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MiniMusicVisualizer(
                                color: AppTheme.metadataColor,
                                width: 5,
                                height: 15,
                                radius: 3,
                                animate: viewModel.isPlaying,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(children: <Widget>[_builStreamTitle()]),
                      const SizedBox(height: 20),
                      SocialNetworkBar(),
                      const SizedBox(height: 20),
                      _buildVolumeSlider(),
                      const SizedBox(height: 20),
                      _buildControlButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: Config.admobAndroidAdUnit.isNotEmpty
                    ? AdmobService.banner
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Cover Image
  Widget _buildStreamCover() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 200,
          minHeight: 200,
          maxWidth: 200,
          maxHeight: 200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: SizedBox.expand(
              child: (viewModel.isPlaying && viewModel.artworkData != null)
                  ? Image.memory(
                      viewModel.artworkData!,
                      key: const ValueKey(2),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      key: const ValueKey(1),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  //Metadata
  Widget _builStreamTitle() {
    return Expanded(
      child: SizedBox(
        height: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoScrollText(
              text: viewModel.isPlaying
                  ? viewModel.artist
                  : Config.appNameScreen,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppTheme.metadataColor,
              ),
            ),
            AutoScrollText(
              text: viewModel.isPlaying
                  ? viewModel.track
                  : Config.appDescription,
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.metadataColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Buton Play
  Widget _buildControlButton(BuildContext context) {
    final viewModel = Provider.of<PlayerScreenModel>(context, listen: true);
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.boxButtonPlay.withAlpha((0.3 * 255).round()),
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppTheme.buttonSplashColor,
            child: SizedBox(
              width: 88,
              height: 88,
              child: Center(
                child: viewModel.isLoading
                    ? SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.buttonPlay,
                          ),
                          strokeWidth: 3,
                        ),
                      )
                    : Icon(
                        viewModel.isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
                        size: 88,
                        color: AppTheme.buttonPlay,
                      ),
              ),
            ),
            onTap: () {
              if (!viewModel.isLoading) {
                viewModel.isPlaying ? viewModel.pause() : viewModel.play();
              }
            },
          ),
        ),
      ),
    );
  }

  //Volume
  Widget _buildVolumeSlider() {
    final viewModel = Provider.of<PlayerScreenModel>(context, listen: true);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.volume_mute, color: AppTheme.iconVolume, size: 30),
          Flexible(
            child: SliderTheme(
              data: SliderThemeData(
                thumbColor: AppTheme.thumbColor,
                activeTrackColor: AppTheme.activeColor,
                inactiveTrackColor: AppTheme.inactiveColor,
              ),
              child: Slider(
                value: viewModel.volume * 100,
                min: 0,
                max: 100,
                divisions: 100,
                label: (viewModel.volume * 100).round().toString(),
                onChanged: (double value) {
                  viewModel.setVolume(value / 100);
                },
              ),
            ),
          ),
          const Icon(Icons.volume_up, color: AppTheme.iconVolume, size: 30),
        ],
      ),
    );
  }
}

class AppMinimizer {
  static const platform = MethodChannel('app/minimizer');

  static Future<void> minimizeApp() async {
    try {
      await platform.invokeMethod('minimizeApp');
    } on PlatformException catch (e) {
      debugPrint("Erro ao minimizar o app: ${e.message}");
    }
  }
}
