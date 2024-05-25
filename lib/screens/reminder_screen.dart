import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../screens/set_reminder_screen.dart';
import '../utils/app_images.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool? isSet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(languages.lblDailyReminders, context: context, actions: [
          IconButton(
            onPressed: () async {
              bool? res = await SetReminderScreen().launch(context);
              if (res == true) {
                setState(() {});
              }
            },
            icon: Icon(Icons.add, color: primaryColor),
          ),
        ]),
        body: notificationStore.mRemindList.isNotEmpty
            ? AnimatedListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: notificationStore.mRemindList.length,
                itemBuilder: (context, index) {
                  DateTime? duration = DateTime.parse(notificationStore.mRemindList[index].duration.validate());
                  String formattedTime = DateFormat.jm().format(duration);
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(12)) : boxDecorationRoundedWithShadow(12, spreadRadius: 0, blurRadius: 6, shadowColor: Colors.grey.shade200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(notificationStore.mRemindList[index].title.validate(), style: boldTextStyle(size: 18)),
                            Container(child: Icon(MaterialCommunityIcons.delete_outline)).paddingAll(4).onTap(() {
                              AwesomeNotifications().cancel(notificationStore.mRemindList[index].id.validate());
                              notificationStore.removeToReminder(notificationStore.mRemindList[index]);
                              setState(() {});
                            })
                          ],
                        ),
                        6.height,
                        Text("${weekdays[notificationStore.mRemindList[index].week.toInt()]} ${formattedTime.validate()} | ${notificationStore.mRemindList[index].subTitle.validate()}", style: secondaryTextStyle()),
                      ],
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                  16.height,
                  Text(languages.lblNotificationEmpty, style: boldTextStyle()),
                ],
              ).center());
  }
}
