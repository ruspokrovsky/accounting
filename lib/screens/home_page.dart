import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';
import 'package:forleha/widgets/base_layout.dart';
import 'package:forleha/widgets/local_date_picker.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';
  List<OrderModel> dataList2 = [];
  List<OrderModel> dataList1 = [];
  List<OrderModel> dataList = [];
  late final Map<DateTime, List<Event>> _kEventSource = {};

  bool isExpanded = false;
  bool isSplash = false;

  DateTime? startPeriod;
  DateTime? currentMonth = DateTime.now();
  DateTime endPeriod = DateTime.now();
  String strPeriod = '';

  @override
  void initState() {
    super.initState();
  }

  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedIndex;

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      _today = day;
      _selectedDay = _today;
      _selectedIndex = null;
      startPeriod = null;
      strPeriod = '';
      //currentMonth = _today;
      //currentMonth = null;
      isExpanded = false;
    });
  }

  void _onCurrentMonth() {
    setState(() {
      currentMonth = DateTime.now();
      _selectedDay = null;
      _selectedIndex = null;
      startPeriod = null;
      strPeriod = '';
      isExpanded = false;
    });
  }


  Future<String?> pickAndReadSqlFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Разрешаем выбирать файлы с любым расширением
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      // Проверяем расширение файла
      if (file.name.endsWith('')) {
        return file.path;
      } else {
        // Если выбранный файл не имеет расширения .db, выводим сообщение об ошибке
        print('Выберите файл с расширением .db');
        return null;
      }
    } else {
      // Пользователь не выбрал файл
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      const Chip(
          side: BorderSide.none,
          padding: EdgeInsets.zero,
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          label: Text('Принятые')),
      const Chip(
          side: BorderSide.none,
          padding: EdgeInsets.zero,
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.purpleAccent,
          ),
          label: Text('Отгруженные')),
      const Chip(
          side: BorderSide.none,
          padding: EdgeInsets.zero,
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.greenAccent,
          ),
          label: Text('Закрытые')),
    ];

    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Если скорость движения влево отрицательна, значит жест справа налево
            // Navigator.pop(context);

            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(''),
            actions: [
              IconButton(
                  onPressed: () async {



                    await pickAndReadSqlFile().then((value) async {
                      try {
                        if (value != null) {
                          Directory documentsDirectory = await getApplicationDocumentsDirectory();
                          File savedDb = File("/data/data/com.example.forleha/databases/db_orders");
                          //File savedDb = File(path.join(documentsDirectory.path, 'db_orders'));
                          await savedDb.writeAsBytes(await File(value).readAsBytes());
                          print('База данных успешно восстановлена');
                        } else {
                          print('Файл базы данных не выбран');
                        }
                      } catch (e) {
                        print('Ошибка при восстановлении базы данных: $e');
                      }

                      setState(() {});
                    });





                    // await pickAndReadSqlFile().then((value) async {
                    //   try{
                    //     File savedDb = File("/data/data/com.example.forleha/databases/db_orders");
                    //     //Directory? folderpathForDbFile = Directory("/storage/emulated/0/Android/data/com.example.forleha/files");
                    //     //await folderpathForDbFile.create();
                    //     await savedDb.copy(value!);
                    //   }
                    //   catch(e){
                    //     print('exception: $e');
                    //   }
                    //   print('value: $value');
                    // } );


                    // DataBaseHelper.getCurrentVersion().then((value)
                    // => print('value: $value'));
                    //
                    // DataBaseHelper.getDbPath().then((value)
                    // => print('value: $value'));


                    //DataBaseHelper().onDBUpgrade();
                    // await openDatabase(
                    //   // Путь к файлу базы данных
                    //   path.join(await getDatabasesPath(), 'db_orders.db'),
                    // // Версия базы данных
                    // onUpgrade: (db, oldVersion, newVersion) async {
                    //     print('-----------------');
                    //     print(oldVersion);
                    //     print(newVersion);
                    //     print('-----------------');
                    // // Проверяем, было ли обновление базы данных
                    // if (oldVersion < newVersion) {
                    // // Вызываем метод добавления новой таблицы
                    // await DataBaseHelper().onDBUpgrade();
                    // }
                    // },
                    // version: 3, // Увеличиваем версию базы данных
                    // );




                  },
                  icon: const Icon(Icons.refresh)),
              IconButton(
                  onPressed: () async {

                    String fileName = 'Заказы от ${Utils.dateParse(milliseconds: DateTime.now().millisecondsSinceEpoch)}';

                    await Utils().saveExcelPurchasingFile(fileName: fileName, data: dataList1)
                        .then((String filePath) async{
                      await OpenFile.open(filePath);
                    });
                  },
                  icon: const Icon(Icons.file_open_outlined)),
              IconButton(
                  onPressed: () async {
                    //await backupDatabase();

                    shareDatabaseFile();
                  },
                  icon: const Icon(Icons.cloud_download_outlined)),
              IconButton(
                  onPressed: () {
                    Navigation().navigateToPositionsScreen(context, OrderModel.empty());
                  },
                  icon: const Icon(Icons.add_chart)),
              IconButton(
                  onPressed: () async {
                    await Navigation()
                        .navigateToCustomersScreen(context)
                        .then((value) {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.person)),
              IconButton(
                  onPressed: () {
                    Navigation.navigateToBankScreen(context);
                  },
                  icon: const Icon(Icons.account_balance_rounded)),
              IconButton(
                  onPressed: () {
                    Navigation.navigateToExpenseScreen(context);
                  },
                  icon: const Icon(Icons.attach_money)),
              IconButton(
                  onPressed: () {
                    Navigation.navigateToHomeScreen(context, CustomerModel.empty());
                  },
                  icon: const Icon(Icons.bar_chart)),
            ],
          ),

          body: FutureBuilder(
            future: DataBaseHelper.getOrders(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return placeHolder();
              } else if (snapshot.hasError) {
                return placeHolder();
              } else if (snapshot.hasData) {
                dataList = snapshot.data!;

                print('dataList: $dataList');

                // dataList = dataList1.where((elem) {
                //   DateTime elementMonth
                //   = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                //   return elementMonth.month == DateTime.now().month;
                // }).toList();




                _kEventSource.clear();


                if (dataList.isNotEmpty) {

                  for (var element in dataList) {
                    DateTime milliseconds = DateTime.fromMillisecondsSinceEpoch(element.addedAt);

                    // Создаем событие на основе дня
                    Event event = Event(
                        '${milliseconds.year}${milliseconds.month}${milliseconds.day}',);

                    // Создаем DateTime.utc() для использования в качестве ключа
                    DateTime dateTimeFromMilliseconds = DateTime.utc(
                      milliseconds.year,
                      milliseconds.month,
                      milliseconds.day,
                    );

                    // Проверяем, существует ли уже список событий для данного дня
                    if (_kEventSource.containsKey(dateTimeFromMilliseconds)) {
                      // Добавляем событие в существующий список
                      _kEventSource[dateTimeFromMilliseconds]!.add(event);
                      // Сортируем список событий по дням
                      _kEventSource[dateTimeFromMilliseconds]!
                          .sort((a, b) => a.title.compareTo(b.title));
                    } else {
                      // Создаем новый список событий для данного дня и добавляем событие в него
                      _kEventSource[dateTimeFromMilliseconds] = [event];
                    }
                  }

                  if (_selectedIndex == 0) {

                    dataList2 = dataList
                        .where((elem) {
                      DateTime elementMonth = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      return (elem.orderStatus == 0
                          &&  elementMonth.month == currentMonth!.month);
                    }).toList();


                    // dataList2 = dataList
                    //     .where((element) => element.orderStatus == 0)
                    //     .toList();
                  }
                  else if (_selectedIndex == 1) {

                    dataList2 = dataList
                        .where((elem) {
                      DateTime elementMonth = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      return (elem.orderStatus == 1
                          &&  elementMonth.month == currentMonth!.month);
                    }).toList();

                    // dataList2 = dataList
                    //     .where((element) => element.orderStatus == 1)
                    //     .toList();
                  }
                  else if (_selectedIndex == 2) {


                    dataList2 = dataList
                        .where((elem) {
                      DateTime elementMonth = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      return (elem.orderStatus == 2
                          &&  elementMonth.month == currentMonth!.month);
                    }).toList();


                    // dataList2 = dataList
                    //     .where((element) => element.orderStatus == 2)
                    //     .toList();
                  }
                  else if (_selectedIndex == 3) {


                    dataList2 = dataList
                        .where((elem) {
                      DateTime elementMonth = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      return (elem.orderStatus == 3
                          &&  elementMonth.month == currentMonth!.month);
                    }).toList();


                    // dataList2 = dataList
                    //     .where((element) => element.orderStatus == 3)
                    //     .toList();
                  }
                  else if (_selectedDay != null) {
                    dataList2 = dataList
                        .where((elem) {
                      DateTime elementMonth = DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      return (elementMonth.day == _today.day
                      &&  elementMonth.month == currentMonth!.month);
                    }).toList();
                  }
                  else if (startPeriod != null) {
                    dataList2 = dataList.where((elem) {
                      // Преобразуем int в DateTime и сравниваем с startPeriod и endPeriod
                      DateTime elementDateTime =
                      DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      //return elementDateTime.isAfter(startPeriod!);
                      return elementDateTime.isAfter(startPeriod!) &&
                          elementDateTime.isBefore(endPeriod);
                    }).toList();

                    strPeriod = '${Utils.dateMonthParse(milliseconds: startPeriod!.millisecondsSinceEpoch)} - ${Utils.dateMonthParse(milliseconds: endPeriod.millisecondsSinceEpoch)}';
                  }
                  else if (currentMonth != null) {
                    dataList2 = dataList.where((elem) {
                      // Преобразуем int в DateTime и сравниваем с startPeriod и endPeriod
                      DateTime elementMonth =
                      DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                      //return elementDateTime.isAfter(startPeriod!);
                      return elementMonth.month == currentMonth!.month;
                    }).toList();
                  }
                  else {
                    dataList2 = dataList;
                  }

                  double total = 0.0;
                  List<double> totalsList =
                  dataList2.map((e) => e.totalSum).toList();

                  if (totalsList.isNotEmpty) {
                    total = totalsList.reduce((value, element) => value + element);
                  }



                  return BaseLayout(
                    onWillPop: () {},
                    isFloatingContainer: true,
                    flexibleContainerChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        //shrinkWrap:true,
                        children: [
                          // ElevatedButton(onPressed: (){
                          //   DataBaseHelper.updateShipmentDate(dataList1.length);
                          // }, child: Text('ww')),
                          TableCalendar<Event>(
                            locale: "ru_RU",
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _today,
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (day) => isSameDay(day, _today),
                            calendarFormat: _calendarFormat,
                            eventLoader: _getEventsForDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color:
                                Theme.of(context).colorScheme.inversePrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            onDaySelected: _onDaySelected,
                            onPageChanged: (focusedDay) {
                              setState(() {
                                startPeriod = null;
                                strPeriod = '';
                                _selectedDay = null;
                                _today = focusedDay;
                                currentMonth = focusedDay;
                                dataList2 = dataList.where((elem) {
                                  // Преобразуем int в DateTime и сравниваем с startPeriod и endPeriod
                                  DateTime elementMonth =
                                  DateTime.fromMillisecondsSinceEpoch(elem.addedAt);
                                  //return elementDateTime.isAfter(startPeriod!);
                                  return elementMonth.month == currentMonth!.month;
                                }).toList();
                              });
                            },
                            headerStyle: const HeaderStyle(
                                //leftChevronVisible: false,
                                //rightChevronVisible: false,
                                formatButtonVisible: false,
                                titleCentered: true),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: <Widget>(context, date, events) {
                                if (events.isNotEmpty) {
                                  return Stack(children: [
                                    Positioned(
                                      right: 10.0,
                                      bottom: -6.0,
                                      child: Container(
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          '${events.length}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange),
                                        ),
                                      ),
                                    ),
                                  ]);
                                }
                              },
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColor),
                              weekendStyle: const TextStyle(fontSize: 12.0, color: Colors.deepOrange),
                            ),
                          ),
                          const Divider(),
                          if(currentMonth != null)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = true;
                                        });
                                      },
                                      child: Text(strPeriod.isNotEmpty? strPeriod :'Фильтр по периоду')),
                                  // TextButton(
                                  //     onPressed: () {
                                  //       _onCurrentMonth();
                                  //     },
                                  //     child: const Text('Текущий месяц')),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(seconds: 2),
                                height: isExpanded ? 250.0 : 0.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Row(
                                      children: [
                                        Expanded(
                                            child: LocalDatePicker(
                                                onChange: (e) {
                                                  startPeriod = e;
                                                },
                                              initialDate: currentMonth!,
                                              kFirstDayMonth: DateTime(currentMonth!.year, currentMonth!.month, 1),
                                              kLastDayMonth: DateTime(currentMonth!.year, currentMonth!.month + 1, 0),)),
                                        const VerticalDivider(),
                                        Expanded(
                                            child: LocalDatePicker(
                                                onChange: (e) {
                                                  endPeriod = e;
                                                },
                                              initialDate: currentMonth!,
                                              kFirstDayMonth: DateTime(currentMonth!.year, currentMonth!.month, 1),
                                              kLastDayMonth: DateTime(currentMonth!.year, currentMonth!.month + 1, 0),)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          child: const Text('Применить'),
                                          onPressed: () {
                                            print('startPeriod: $startPeriod');
                                            print('endPeriod: $endPeriod');

                                            _selectedDay = null;
                                            //currentMonth = null;
                                            _selectedIndex = -1;
                                            isExpanded = false;
                                            setState(() {});
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Закрыть'),
                                          onPressed: () {
                                            setState(() {
                                              isExpanded = false;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          SizedBox(
                            height: 28,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          child: items[index],
                                          onTap: () {
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                          },
                                        );
                                      }),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedDay = null;
                                        _selectedIndex = -1;
                                        startPeriod = null;
                                        strPeriod = '';
                                        //currentMonth = null;
                                        //dataList2 = dataList;
                                        isExpanded = false;
                                      });
                                    },
                                    icon: const Icon(Icons.table_rows))
                              ],
                            ),
                          ),
                          const Divider(),
                          Center(
                            child: RichSpanText(
                                spanText: SpanTextModel(
                                    title: '',
                                    data: Utils.numberParse(value: total),
                                    postTitle: ' KGS')),
                          ),

                        ],
                      ),
                    ),
                    flexibleSpaceBarTitle: const SizedBox.shrink(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: dataList2.length,
                              (BuildContext context, int index) {
                            Color? statusColor;
                            String? statusChar;

                            if (dataList2[index].orderStatus == 0) {
                              statusColor = Colors.deepOrangeAccent;
                              statusChar = 'принят';
                            } else if (dataList2[index].orderStatus == 1) {
                              statusColor = Colors.purpleAccent;
                              statusChar = 'отгружен';
                            } else if (dataList2[index].orderStatus == 2) {
                              statusColor = Colors.greenAccent;
                              statusChar = 'оплачен';
                            }

                            return Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              dataList2[index].customerName,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        //RichSpanText(spanText: SpanTextModel(title:'Заказчик: ', data: dataList2[index]!.customerName, postTitle: '')),
                                        // RichSpanText(
                                        //     spanText: SpanTextModel(
                                        //         title: '',
                                        //         data: dataList2[index]!
                                        //             .customerPhone,
                                        //         postTitle: '')),
                                        RichSpanText(
                                            spanText: SpanTextModel(
                                                title: 'принят: ',
                                                data: Utils.dateTimeParse(
                                                    milliseconds: dataList2[index].addedAt),
                                                postTitle: '')),
                                        RichSpanText(
                                            spanText: SpanTextModel(
                                                title: 'отгружен: ',
                                                data: Utils.dateTimeParse(
                                                    milliseconds: dataList2[index].shipmentDate),
                                                postTitle: '')),
                                        RichSpanText(
                                            spanText: SpanTextModel(
                                                title: 'оплачен: ',
                                                data: Utils.dateTimeParse(
                                                    milliseconds: dataList2[index].acceptDate),
                                                postTitle: '')),
                                        const SizedBox(
                                          height: 6.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex:3,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await _addStatusDialog(
                                                      orderModel:
                                                      dataList2[index])
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: statusColor,
                                                ),
                                                child: Text(statusChar!,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),),

                                            Expanded(
                                              flex:1,
                                              child: PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                      value: 0,
                                                      child: Icon(Icons.call)),
                                                  const PopupMenuItem(
                                                      value: 1,
                                                      child: Icon(Icons.mail_outline)),
                                                  const PopupMenuItem(
                                                      value: 2,
                                                      child: Icon(Icons.details)),

                                                ],
                                                onSelected: (int ind){
                                                  if(ind == 0){
                                                    launchUrlString('tel://${dataList2[index].customerPhone}');
                                                  }
                                                  else if(ind == 1){

                                                      // Замените номер телефона на нужный
                                                      String phoneNumber = dataList2[index].customerPhone;

                                                      // Здесь можно также добавить текст сообщения
                                                      String message = 'Приветствую, ${dataList2[index].customerName}!';

                                                      // Формируем URL для отправки сообщения в WhatsApp
                                                      String url = 'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';

                                                      // Открываем WhatsApp
                                                      launch(url);

                                                  }
                                                  else if(ind == 2){
                                                  Navigation.navigateToOrderPositionsScreen(
                                                  context,
                                                  dataList2[index]);}

                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      Navigation.navigateToOrderPositionsScreen(
                                          context, dataList2[index]);
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(

                          child: SizedBox(height: 80,)
                      )
                    ],
                    isPinned: false,
                    radiusCircular: 0.0,
                    flexContainerColor: Colors.white,
                    expandedHeight: 500.0,
                  );

                } else {
                  return const Center(
                    child: Text('Нет данных'),
                  );
                }
              } else {
                return const Center(
                  child: Text('Нет данных'),
                );
              }
            },
          ),
          //floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigation()
                  .navigateToCustomersScreen(context)
                  .then((value) {
                setState(() {});
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     FloatingActionButton(
          //       onPressed: () async {
          //       //DataBaseHelper.getDbPath();
          //       DataBaseHelper.restoreDb();
          //
          //           },
          //       tooltip: 'Increment',
          //       heroTag: '12',
          //       child: const Icon(Icons.category_outlined),
          //     ),
          //     const SizedBox(width: 16.0,),
          //     FloatingActionButton(
          //       onPressed: () async {
          //         //DataBaseHelper.getDbPath();
          //         DataBaseHelper.backupDb();
          //
          //       },
          //       tooltip: 'Increment',
          //       heroTag: '10',
          //       child: const Icon(Icons.refresh),
          //     ),
          //     const SizedBox(width: 16.0,),
          //     FloatingActionButton(
          //       onPressed: () async {
          //         DataBaseHelper.deleteDb();
          //       },
          //       tooltip: 'Increment',
          //       heroTag: '11',
          //       child: const Icon(Icons.delete),
          //     ),
          //     const SizedBox(width: 16.0,),
          //     FloatingActionButton(
          //       onPressed: () async {
          //         await Navigation()
          //             .navigateToCustomersScreen(context)
          //             .then((value) {
          //           setState(() {});
          //         });
          //       },
          //       tooltip: 'Increment',
          //       child: const Icon(Icons.add),
          //     ),
          //     const SizedBox(width: 26.0,),
          //   ],
          // ),
        ),);

  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _kEventSource[day] ?? [];
  }

  Future<void> _addStatusDialog({required OrderModel orderModel}) async {
    int newOrderStatus = 0;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  actionsPadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.all(8.0),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: Column(
                    children: [
                      Text(orderModel.customerName),
                      Text(orderModel.customerPhone),
                    ],
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(3.0),
                    child: DropdownMenu<String>(
                      //width:MediaQuery.of(context).size.width - 16,
                      label: const Text('Статуса заказа'),
                      onSelected: (String? value) {
                        if (value == 'Заказ принят') {
                          newOrderStatus = 0;
                        } else if (value == 'Заказ отгружен') {
                          newOrderStatus = 1;
                        } else if (value == 'Заказ оплачен') {
                          newOrderStatus = 2;
                        }
                        setState(() {});
                      },
                      dropdownMenuEntries: [
                        'Заказ принят',
                        'Заказ отгружен',
                        'Заказ оплачен',
                      ].map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          leadingIcon: CircleAvatar(
                              radius: 10,
                              backgroundColor: (value == 'Заказ принят')
                                  ? Colors.deepOrangeAccent
                                  : (value == 'Заказ отгружен')
                                      ? Colors.purpleAccent
                                      : (value == 'Заказ оплачен')
                                          ? Colors.greenAccent
                                          : null),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () async {
                        await DataBaseHelper.updateOrderStatus(
                                orderId: orderModel.id, status: newOrderStatus)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Установиить'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () async {
                        await DataBaseHelper.deleteOrderAndPositions(orderModel)
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text('Удалить заказ'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Отменить'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )));
  }

  Widget placeHolder(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
    );
  }
}

Future<void> backupDatabase() async {
  try {
    // Получаем путь к директории, где хранится база данных
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(documentsDirectory.path, 'db_orders.db');



    // Получаем путь к директории, куда будем сохранять резервную копию
    Directory? backupDirectory = await getExternalStorageDirectory();
    String backupPath = path.join(backupDirectory!.path, 'backup_database.db');

    // Копируем файл базы данных
    await File(dbPath).copy(backupPath);

    print('Резервная копия успешно создана: $backupPath');
    //print('Резервная копия успешно создана: $dbPath');
  } catch (e) {
    print('Ошибка при создании резервной копии базы данных: $e');
  }
}

void shareDatabaseFile() async {
  try {
    // Получаем путь к файлу базы данных
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //String dbPath = '${documentsDirectory.path}/db_orders.db';
    String dbPath = '/data/data/com.example.forleha/databases/db_orders';
    //String dbPath = path.join(documentsDirectory.path, 'db_orders');

    print('dbPath: ${File(dbPath)}');

    // Проверяем, существует ли файл
    if (await File(dbPath).exists()) {
      // Отправляем файл нашего базы данных
      await Share.shareFiles([dbPath], text: 'Резервная копия базы данных');

      //await Share.share('check out my website https://example.com', subject: 'Look what I made!');



    } else {
      print('Файл базы данных не найден.');
    }
  } catch (e) {
    print('Ошибка при отправке файла: $e');
  }
}

