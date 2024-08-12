import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class LocalDatePicker extends StatelessWidget {
  final Function onChange;
  final DateTime initialDate;
  final DateTime kFirstDayMonth;
  final DateTime kLastDayMonth;
  const LocalDatePicker({Key? key,
    required this.onChange,
    required this.initialDate,
    required this.kFirstDayMonth,
    required this.kLastDayMonth,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      //looping: true,
      // default is not looping
      //firstDate: DateTime(2024),
      //DateTime(1960),
      //lastDate: DateTime(2035),
      firstDate: kFirstDayMonth,
      lastDate: kLastDayMonth,
      initialDate: initialDate,//февраль 2020 г.
      dateFormat: "dd",
      //dateFormat: "dd-MM-yy",
      locale: DatePicker.localeFromString('ru'),
      onChange: (DateTime newDate, _) => onChange(newDate),
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.transparent,
        itemTextStyle:
        TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 19),
        dividerColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
