import 'package:flutter/material.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/widgets.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/reminder_model.dart';
import '../utils/app_colors.dart';
import '../components/notification_utils.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/constants.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class SetReminderScreen extends StatefulWidget {
  static String tag = '/SetReminderScreen';

  final bool? isDaily;

  SetReminderScreen({this.isDaily = false});

  @override
  SetReminderScreenState createState() => SetReminderScreenState();
}

class SetReminderScreenState extends State<SetReminderScreen> {
  bool? isSet = false;
  DateTime _dateTime = DateTime.now();

  DateTime now = DateTime.now();
  int? selectedDay;
  int? currentIndex = -1;

  TextEditingController mReminderNameCount = TextEditingController();
  TextEditingController mDescriptionCont = TextEditingController();

  FocusNode mNameFocus = FocusNode();
  FocusNode mDescriptionFocus = FocusNode();

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

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
      appBar: appBarWidget("", context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hourMinute12H(),
            Divider(),
            8.height,
            if (widget.isDaily != true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblRepeat, style: boldTextStyle(size: 20)),
                  8.height,
                  Text(languages.lblEveryday, style: primaryTextStyle(color: primaryColor, size: 14)),
                  16.height,
                  HorizontalList(
                      padding: EdgeInsets.zero,
                      itemCount: weekdays.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(12),
                                color: selectedDay == index ? primaryColor : primaryOpacity,
                                child: Text(weekdays[index].substring(0, 1).toUpperCase(), style: boldTextStyle(color: selectedDay == index ? white : primaryColor)).center())
                            .cornerRadiusWithClipRRect(100)
                            .onTap(() {
                          selectedDay = index;
                          setState(() {});
                        });
                      }),
                  24.height,
                ],
              ),
            Text(languages.lblReminderName, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            8.height,
            AppTextField(
              controller: mReminderNameCount,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mNameFocus,
              nextFocus: mDescriptionFocus,
              decoration: defaultInputDecoration(context, label: languages.lblEnterReminderName),
            ),
            24.height,
            Text(languages.lblDescription, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            8.height,
            AppTextField(
              controller: mDescriptionCont,
              textFieldType: TextFieldType.OTHER,
              isValidationRequired: true,
              focus: mDescriptionFocus,
              decoration: defaultInputDecoration(context, label: languages.lblEnterDescription),
            ),
            24.height,
            AppButton(
              text: languages.lblSave,
              width: context.width(),
              color: primaryColor,
              onTap: () async {
                if (widget.isDaily == true) {
                  for (int i = 0; i < 7; i++) {
                    await AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: i,
                        channelKey: 'basic_channel',
                        title: mReminderNameCount.text.validate(),
                        body: mDescriptionCont.text.validate(),
                      ),
                      schedule: NotificationCalendar(weekday: i, hour: _dateTime.hour, minute: _dateTime.minute, second: 0, allowWhileIdle: true),
                    );
                  }
                } else {
                  int day = selectedDay.validate() + 1;
                  ReminderModel reminderModel = ReminderModel();
                  reminderModel.id = notificationStore.mRemindList.length + 1;
                  reminderModel.status = 0;
                  reminderModel.duration = _dateTime.toString();
                  reminderModel.week = day.toString();
                  reminderModel.title = mReminderNameCount.text.validate();
                  reminderModel.subTitle = mDescriptionCont.text.validate();
                  notificationStore.addToReminder(reminderModel);
                  NotificationWeekAndTime(dayOfTheWeek: day, timeOfDay: _dateTime, title: mReminderNameCount.text.validate(), subTitle: mDescriptionCont.text.validate());
                  await AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: notificationStore.mRemindList.length + 1,
                      channelKey: 'scheduled_channel',
                      title: mReminderNameCount.text.validate(),
                      body: mDescriptionCont.text.validate(),
                    ),
                    schedule: NotificationCalendar(weekday: day, hour: _dateTime.hour, minute: _dateTime.minute, second: 0, allowWhileIdle: true, repeats: true),
                  );
                }
                finish(context, true);
                setState(() {});
              },
            ),
            16.height,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  Widget hourMinute12H() {
    return new TimePickerSpinner(
      spacing: 50,
      normalTextStyle: boldTextStyle(size: 24, color: textColor),
      highlightedTextStyle: boldTextStyle(size: 28),
      alignment: Alignment.center,
      is24HourMode: false,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
