import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/LiveStream.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/progress_setting_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';

class ProgressSettingScreen extends StatefulWidget {
  static String tag = '/ProgressSetting';

  @override
  ProgressSettingScreenState createState() => ProgressSettingScreenState();
}

class ProgressSettingScreenState extends State<ProgressSettingScreen> {
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
      appBar: appBarWidget(languages.lblMetricsSettings, context: context),
      body: Observer(builder: (context) {
        return AnimatedListView(
          itemCount: userStore.mProgressList.length,
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            userStore.mProgressList.sort((a, b) => a.id!.compareTo(b.id!));
            ProgressSettingModel data = userStore.mProgressList[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              margin: EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: data.isEnable == true
                      ? primaryColor
                      : appStore.isDarkMode
                          ? context.scaffoldBackgroundColor
                          : cardLightColor,
                  border: Border.all(color: data.isEnable == true ? primaryColor.withOpacity(0.80) : GreyLightColor)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${data.name.validate()}',
                        style: boldTextStyle(
                            color: data.isEnable == true
                                ? Colors.white
                                : appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                      ),
                      data.isEnable == true ? Image.asset(ic_radio_fill, height: 20, width: 20, color: Colors.white) : Image.asset(ic_radio, color: primaryColor, height: 20, width: 20),
                    ],
                  ),
                  4.height,
                  // Divider(),
                ],
              ).paddingSymmetric(vertical: 4).onTap(() async {
                ProgressSettingModel mSetting = ProgressSettingModel();
                mSetting.id = data.id;
                mSetting.name = data.name;
                mSetting.isEnable = userStore.mProgressList[index].isEnable == true ? false : true;
                userStore.updateProgress(mSetting);
                LiveStream().emit(PROGRESS_SETTING);
                setState(() { });
              }),
            );
          },
        );
      }),
    );
  }
}
