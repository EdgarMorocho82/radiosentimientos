import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/constants/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialNetworkBar extends StatefulWidget {
  const SocialNetworkBar({super.key});

  @override
  State<SocialNetworkBar> createState() => _SocialNetworkBarState();
}

class _SocialNetworkBarState extends State<SocialNetworkBar> {
  final Map<String, bool> _pressed = {
    'youtube': false,
    'instagram': false,
    'twitter': false,
    'facebook': false,
    'site': false,
    'whatsapp': false,
  };

  void _handleTap(String key, Uri url) {
    setState(() => _pressed[key] = true);
    _launchInBrowser(url);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _pressed[key] = false);
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildIcon({
    required String key,
    required bool visible,
    required FaIconData icon,
    required Uri url,
    EdgeInsets padding = const EdgeInsets.only(right: 10.0),
  }) {
    if (!visible) return const SizedBox();

    return Padding(
      padding: padding,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _pressed[key]! ? 0.7 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.boxSocialIconColor,
            boxShadow: [
              BoxShadow(
                color: AppTheme.boxSocialIconColor,
                blurRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: IconButton(
            icon: FaIcon(icon, size: 30.0, color: AppTheme.iconSocialColor),
            onPressed: () => _handleTap(key, url),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIcon(
          key: 'youtube',
          visible: Config.youtube.isNotEmpty,
          icon: FontAwesomeIcons.youtube,
          url: Uri.parse(Config.youtube),
        ),
        _buildIcon(
          key: 'instagram',
          visible: Config.instagram.isNotEmpty,
          icon: FontAwesomeIcons.instagram,
          url: Uri.parse(Config.instagram),
        ),
        _buildIcon(
          key: 'twitter',
          visible: Config.twitter.isNotEmpty,
          icon: FontAwesomeIcons.xTwitter,
          url: Uri.parse(Config.twitter),
        ),
        _buildIcon(
          key: 'facebook',
          visible: Config.facebook.isNotEmpty,
          icon: FontAwesomeIcons.facebook,
          url: Uri.parse(Config.facebook),
        ),
        _buildIcon(
          key: 'site',
          visible: Config.site.isNotEmpty,
          icon: FontAwesomeIcons.globe,
          url: Uri.parse(Config.site),
        ),
        _buildIcon(
          key: 'whatsapp',
          visible: Config.whatsapp.isNotEmpty,
          icon: FontAwesomeIcons.whatsapp,
          url: Uri.parse('whatsapp://send?phone=${Config.whatsapp}'),
          padding: const EdgeInsets.only(right: 1.0),
        ),
      ],
    );
  }
}
