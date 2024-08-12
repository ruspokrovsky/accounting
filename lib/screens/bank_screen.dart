
import 'package:flutter/material.dart';
import 'package:forleha/models/bank_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';
import 'package:forleha/widgets/base_layout.dart';
import 'package:forleha/widgets/local_date_picker.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:table_calendar/table_calendar.dart';

class BankScreen extends StatefulWidget {
  static const String routeName = 'bankScreen';

  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  String query = '';
  String variant = 'positiv';
  List<CurrentBankModel> dataList3 = [];
  List<BankModel> dataList2 = [];
  List<BankModel> dataList1 = [];
  List<BankModel> dataList = [];
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Резерв'),
        actions: const [],
      ),

      body: FutureBuilder(
        future: DataBaseHelper.getBank(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return placeHolder();
          } else if (snapshot.hasError) {
            return placeHolder();
          } else if (snapshot.hasData) {
            dataList = snapshot.data!;


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

              if (_selectedDay != null) {
                dataList2 = dataList.where((elem) {
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
              double totalAvanse = 0.0;
              List<double> totalsList = dataList2.map((e) => e.admissionSum).toList();
              List<double> totalsAvansList = dataList2.map((e) => e.expenseSum).toList();

              if (totalsList.isNotEmpty) {
                total = totalsList.reduce((value, element) => value + element);
                totalAvanse = totalsAvansList.reduce((value, element) => value + element);
              }

              for (var element in dataList2) {
                if(variant == 'positiv' && element.admissionSum != 0){
                  dataList3.add(CurrentBankModel(
                      id: element.id,
                      sum: Utils.numberParse(value: element.admissionSum),
                      date: Utils.dateTimeParse(milliseconds: element.addedAt),
                      description: element.admissionDescription));
                }
                else if(variant == 'negativ' && element.expenseSum != 0){
                  dataList3.add(CurrentBankModel(
                      id: element.id,
                      sum: Utils.numberParse(value: element.expenseSum),
                      date: Utils.dateTimeParse(milliseconds: element.addedAt),
                      description: element.expenseDescription));
                }
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
                                  icon: const Icon(Icons.table_rows)),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      dataList3 = [];
                                      variant = 'positiv';
                                      _selectedDay = null;
                                      _selectedIndex = -1;
                                      startPeriod = null;
                                      strPeriod = '';
                                      //currentMonth = null;
                                      //dataList2 = dataList;
                                      isExpanded = false;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_downward)),
                              RichSpanText(
                                  spanText: SpanTextModel(
                                      title: '',
                                      data: Utils.numberParse(value: total),
                                      postTitle: '')),
                            ],
                          ),

                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      dataList3 = [];
                                      variant = 'negativ';
                                      _selectedDay = null;
                                      _selectedIndex = -1;
                                      startPeriod = null;
                                      strPeriod = '';
                                      //currentMonth = null;
                                      //dataList2 = dataList;
                                      isExpanded = false;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_upward)),
                              RichSpanText(
                                  spanText: SpanTextModel(
                                      title: '',
                                      data: Utils.numberParse(value: totalAvanse),
                                      postTitle: '')),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                flexibleSpaceBarTitle: const SizedBox.shrink(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: dataList3.length,
                          (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichSpanText(
                                      spanText: SpanTextModel(
                                          title: 'KGS: ',
                                          data: dataList3[index].sum,
                                          postTitle: '')),
                                  RichSpanText(
                                      spanText: SpanTextModel(
                                          title: 'От: ',
                                          data: dataList3[index].date,
                                          postTitle: '')),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                            const Divider(),
                          ],
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
                expandedHeight:  isExpanded ? 750.0 : 500.0,
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

      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: () async {
              await Navigation()
                  .navigateToCreateAdmissionScreen(context)
                  .then((value) {
                setState(() {});
              });
            },
            tooltip: 'Поступление',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16.0,),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () async {

              await Navigation()
                  .navigateToCreateAvansScreen(context)
                  .then((value) {
                setState(() {});
              });

            },
            tooltip: 'Аванс',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16.0,),
        ],
      ),
    );

  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _kEventSource[day] ?? [];
  }

  Widget placeHolder(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
    );
  }
}
