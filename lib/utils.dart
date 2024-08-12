
import 'dart:collection';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:forleha/models/order_model.dart';
import 'package:path_provider/path_provider.dart';

class Utils{

  static dateParse({required int milliseconds}){
    if(milliseconds == 0){
      return '';
    }else{
      return DateFormat('dd.MM.yy').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    }

  }

  static timeParse({required int milliseconds}){
    if(milliseconds == 0){
      return '';
    }
    else {
      return DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    }
  }

  static dateMonthParse({required int milliseconds}){
    if(milliseconds == 0){
      return '';
    }else{
      return DateFormat('dd.MM').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    }

  }

  static dateTimeParse({required int milliseconds}){
    if(milliseconds == 0){
      return '';
    }
    else {
      return DateFormat('dd.MM.yy / HH:mm').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    }
  }

  static monthParse({required int milliseconds}){
    if(milliseconds == 0){
      return '';
    }
    else {
      return DateFormat('MM').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    }
  }

  static numberParse({required dynamic value}){
    return NumberFormat.decimalPattern('RU').format(value);
  }


  Future<String> saveExcelPurchasingFile({
    required String fileName,
    required List<OrderModel> data}) async {
    final excel = Excel.createExcel();
    final sheetObject = excel['Sheet1'];
    List<dynamic> headers = [
      "№",
      "Заказчик",
      "Телефон",
      "Дата принятия",
      "Дата оплаты",
      "Статус",
      "Сумма",
    ];
    sheetObject.appendRow(headers.map((value) => TextCellValue(value)).toList());
    String status = '';
    for(int i = 0; i < data.length; i++){

      if(data[i].orderStatus == 0){
        status = 'Заказ принят';
      }
      else if(data[i].orderStatus == 1){
        status = 'Заказ отгружен';
      }
      else if(data[i].orderStatus == 2){
        status = 'Заказ оплачен';
      }


      int indexNum = i+1;
      sheetObject.appendRow([
        TextCellValue(indexNum.toString()),
        TextCellValue(data[i].customerName),
        TextCellValue(data[i].customerPhone),
        TextCellValue(dateParse(milliseconds: data[i].addedAt)),
        TextCellValue(dateParse(milliseconds: data[i].acceptDate)),
        TextCellValue(status),
        TextCellValue(numberParse(value: data[i].totalSum)),
      ]);
    }

    final excelBytes = excel.encode();

    final docsDir = await getApplicationDocumentsDirectory();
    var filePath = "${docsDir.path}/$fileName.xlsx";


    final file = File(filePath);
    await file.writeAsBytes(excelBytes!);

    return filePath;
  }


}


/// Example event class.
class Event {
  final String title;

  const Event(this.title,);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = {
//   DateTime.utc(2024, 3, 1): [Event('Событие 1'),Event('Событие 2'),Event('Событие 3'),Event('Событие 4')],
//   DateTime.utc(2024, 2, 5): [Event('Событие 2')],
//   DateTime.utc(2024, 2, 10): [Event('Событие 3')],
//   // Добавьте свои реальные данные событий здесь
// };


// final _kEventSource2 = {
//
//   for (var item in List.generate(50, (index) => index))
//
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) }
//   ..addAll({kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);

final kFirstDayMonth = DateTime(kToday.year, kToday.month, 1);
final kLastDayMonth = DateTime(kToday.year, kToday.month + 1, 0);

