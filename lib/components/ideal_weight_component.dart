import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/double_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import '../extensions/text_styles.dart';
import 'count_down_progress_indicator.dart';

class IdealWeightComponent extends StatefulWidget {
  static String tag = '/IdealWeightComponent';

  @override
  IdealWeightComponentState createState() => IdealWeightComponentState();
}

class IdealWeightComponentState extends State<IdealWeightComponent> with TickerProviderStateMixin {
  double? mKg;
  double? mCm;
  double? mBMI;
  double? mIdealWeight;

  late AnimationController controller;
  CountDownController mCountDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    convertFeetToCm();
    print("mIdealWeight-->"+userStore.gender.toString());


    if(userStore.gender=="male"){
      if(mCm.validate()>=155.448){
        convertCMToFeet();
       // mIdealWeight =52 + (3(1.9));
        print("mCm"+mCm.toString());
      }
    }else{
      if(mCm.validate()>=155.448){
        convertCMToFeet();

        // mIdealWeight =45.5+(0.91*((mCm.validate())-152.4));
        print("mIdealWeight"+mIdealWeight.toString());
        print("mCm"+mCm.toString());
      }
    }
    super.initState();
  }

  //Convert CM to Feet
  void convertCMToFeet() {
    double a = double.parse(mCm.validate().toString().isEmptyOrNull ? "0.0" :mCm.validate().toString()) * 0.0328;

    final double abc = 1.4;
    int a1 = int.parse(abc.toString().split(".")[0]);
    int b = int.parse(abc.toString().split(".")[1]);
    print("Feet->"+a1.toString());
    print("Feet->"+b.toString());
    print("Feet->"+a.toStringAsFixed(2).toString());
  }

  // convert Feet to cm
  void convertFeetToCm() {
    mCm = userStore.heightUnit == FEET ? double.parse(userStore.height.validate()) * 30.48 : double.parse(userStore.height.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(16), backgroundColor: context.cardColor) : boxDecorationRoundedWithShadow(16, backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: appStore.isDarkMode ? Colors.black : Colors.white),
                padding: EdgeInsets.all(6),
                child: Image.asset(ic_calories, width: 22, height: 22, color: primaryColor),
              ),
              16.width,
              ///TODO
              Text("Ideal Weight", style: boldTextStyle(size: 18, color: appStore.isDarkMode ? primaryColor : black), overflow: TextOverflow.ellipsis, maxLines: 1).expand(),
            ],
          ),
          12.height,
          Column(
            children: [
              Text(mBMI.toString().isEmptyOrNull ? "0" : mBMI!.toStringAsFixed(2).validate(), style: boldTextStyle(size: 22, height: 0)),
              Text(languages.lblKcal, style: secondaryTextStyle()),
            ],
          ).center(),
          8.height,
        ],
      ),
    );
  }
}
