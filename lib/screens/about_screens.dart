import 'package:flutter/material.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/constants/language.dart';
import 'package:radioxr/constants/theme.dart';
import 'package:radioxr/models/markdown_models.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.width * 0.08;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        elevation: 0.0,
        title: const Text(Language.aboutUs,
            style: TextStyle(color: AppTheme.foregroundColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: spacing),
            _buildAbout(),
            _buildProfileContainer(),
            const SizedBox(height: 10),
            _buildDescriptionContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbout() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.asset(
        'assets/images/logo.png',
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProfileContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Text(
                Config.appNameScreen,
                style: TextStyle(
                  color: AppTheme.aboutUsTitleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w500,
                    FontWeight.w700,
                    0.9,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                Config.appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.aboutUsDescriptionColor,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w500,
                    FontWeight.w700,
                    0.9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.aboutContainerBackgroundColor,
          ),
          child: MarkdownText(
            filename: 'assets/text/about.md',
            textStyle: TextStyle(
              color: AppTheme.aboutUsFontColor,
              fontSize: 16,
              height: 1.5,
              fontFamily: 'Custom',
              fontWeight:
                  FontWeight.lerp(FontWeight.w400, FontWeight.w600, 0.9),
            ),
          ),
        ),
      ],
    );
  }
}
