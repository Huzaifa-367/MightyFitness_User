import 'package:flutter/material.dart';
import '../screens/youtube_player_screen.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../extensions/colors.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../utils/app_colors.dart';
import 'chewie_screen.dart';

class TipsScreen extends StatefulWidget {
  static String tag = '/TipsScreen';
  final String? mTips;
  final String? mExerciseImage;
  final String? mExerciseVideo;
  final String? mExerciseInstruction;

  TipsScreen({this.mTips, this.mExerciseVideo, this.mExerciseImage, this.mExerciseInstruction});

  @override
  TipsScreenState createState() => TipsScreenState();
}

class TipsScreenState extends State<TipsScreen> {
  bool select = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblTipsInst, context: context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.mExerciseVideo!.validate().contains("https://youtu")
                ? AspectRatio(aspectRatio: 12 / 7, child: YoutubePlayerScreen(url: widget.mExerciseVideo.validate(), img: widget.mExerciseImage.validate()))
                : ChewieScreen(widget.mExerciseVideo.validate(), widget.mExerciseImage.validate()).center(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : primaryOpacity),
                  child: Column(
                    children: [
                      Row(children: [
                        Icon(Icons.info_outline, color: primaryColor, size: 25),
                        10.width,
                        Text(languages.lblTips, style: primaryTextStyle(size: 18, color: appStore.isDarkMode ? white : textPrimaryColor)).expand(),
                        Icon(select ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up, color: primaryColor, size: 30),
                      ]),
                      8.height.visible(!select),
                      Container(
                        child: htmlWidget(context, widget.mTips.validate(), textPrimaryColor, primaryTextStyle(color: appStore.isDarkMode ? white : textPrimaryColor)),
                      ).visible(!select),
                    ],
                  ),
                ).onTap(() {
                  setState(() {
                    select = !select;
                  });
                }),
                16.height,
                Text(languages.lblInstruction, style: boldTextStyle()).paddingSymmetric(horizontal: 16).visible(!widget.mExerciseInstruction.isEmptyOrNull),
                16.height,
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: htmlWidget(context, widget.mExerciseInstruction.validate(), textPrimaryColorGlobal, primaryTextStyle()),
                  padding: EdgeInsets.only(right: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
