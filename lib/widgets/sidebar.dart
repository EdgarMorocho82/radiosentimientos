import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/constants/language.dart';
import 'package:radioxr/models/markdown_models.dart';
import 'package:radioxr/screens/about_screens.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../constants/theme.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({super.key});
  final inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.sidebarBackground,
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [_buildHeader(), ..._buildItems(context)],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              Config.appNameScreen,
              style: TextStyle(
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  AppTheme.fontWeight,
                ),
                fontSize: 16,
                height: 1.8,
                color: AppTheme.sidebarTextColor,
              ),
            ),
            Text(
              Config.appDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  AppTheme.fontWeight,
                ),
                fontSize: 14,
                height: 1.6,
                color: AppTheme.sidebarTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      // About Us
      _buildListTile(
        icon: Icons.group_outlined,
        title: Language.aboutUs,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AboutView.routeName);
        },
      ),
      // Share
      _buildListTile(
        icon: Icons.share_outlined,
        title: Language.share,
        onTap: () {
          Navigator.pop(context);
          final box = context.findRenderObject() as RenderBox?;
          final sharePosition = box!.localToGlobal(Offset.zero) & box.size;

          if (Platform.isAndroid) {
            Share.share(
              '${Config.textShare} - ${Config.appNameScreen} \n'
              'https://play.google.com/store/apps/details?id=${Config.androidPackage}',
            );
          } else {
            Share.share(
              '${Config.textShare} - ${Config.appNameScreen} \n'
              'https://apps.apple.com/app/id${Config.appleID}',
              sharePositionOrigin: sharePosition,
            );
          }
        },
      ),
      // Rate Us
      _buildListTile(
        icon: Icons.star_outline,
        title: Language.rateUs,
        onTap: () {
          Navigator.pop(context);
          inAppReview.openStoreListing(appStoreId: Config.appleID);
        },
      ),
      // Privacy Policy
      _buildListTile(
        icon: Icons.description_outlined,
        title: Language.privacyPolicy,
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Markdown(filename: 'assets/text/privacy_policy.md');
            },
          );
        },
      ),

      const SizedBox(height: 20),
      /*Container(
        padding: const EdgeInsets.only(left: 20),
        child: const Text(
          Language.moreInformation,
          style: TextStyle(color: AppTheme.sidebarTextColor),
        ),
      ),*/
      const ListTile(
        /*leading: FaIcon(
          FontAwesomeIcons.code,
          color: AppTheme.sidebarTextColor,
        ),*/
        title: Text(
          textAlign: TextAlign.center,
          Language.versonApp,
          style: TextStyle(fontSize: 15, color: AppTheme.sidebarTextColor),
        ),
        subtitle: Text(
          textAlign: TextAlign.center,
          Language.numberVersonApp,
          style: TextStyle(fontSize: 14, color: AppTheme.sidebarTextColor),
        ),
      ),
      const SizedBox(),
      Container(
        padding: const EdgeInsets.only(left: 1),
        child: const Text(
          Language.developer,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.sidebarTextColor),
        ),
      ),
    ];
  }

  Widget _buildListTile({
    IconData? icon,
    required String title,
    required Function() onTap,
  }) => ListTile(
    leading: Icon(
      icon,
      size: 24,
      semanticLabel: '$title Icon',
      color: AppTheme.sidebarTextColor,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.lerp(
          FontWeight.w500,
          FontWeight.w700,
          AppTheme.fontWeight,
        ),
        fontSize: 16,
        color: AppTheme.sidebarTextColor,
      ),
    ),
    onTap: onTap,
  );
}
