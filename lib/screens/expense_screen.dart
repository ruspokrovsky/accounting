import 'package:flutter/material.dart';
import 'package:forleha/models/expense_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:table_calendar/table_calendar.dart';

class ExpenseScreen extends StatefulWidget {
  static const String routeName = 'expenseScreen';

  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  int _selectedIndex = 0;

  List<Widget> items = [
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.join_inner),
        label: Text('Все')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.wb_incandescent_outlined),
        label: Text('Коммуналка')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.school),
        label: Text('Образование')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.cake),
        label: Text('Досуг')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.restaurant),
        label: Text('Продукты')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.pets),
        label: Text('Питомцы')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.add_business),
        label: Text('Хозтовары')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: Icon(Icons.add_chart),
        label: Text('Сырье')),
    const Chip(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          radius: 10,
          backgroundColor: Colors.grey,
        ),
        label: Text('Другое')),
  ];

  late final Map<DateTime, List<Event>> _kEventSource = {};
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;

  final CalendarFormat _calendarFormat = CalendarFormat.week;

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      _today = day;
      _selectedDay = _today;
      _selectedIndex = -1;
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _kEventSource[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расходы'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: DataBaseHelper.getExpense(),
        builder: (context, AsyncSnapshot<List<ExpenseModel?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            List<ExpenseModel?>? ordersDataList = snapshot.data;
            List<ExpenseModel?> dataList = [];
            List<ExpenseModel?> dataList2 = [];
            _kEventSource.clear();
            if (ordersDataList != null && ordersDataList.isNotEmpty) {
              if (_selectedIndex == 0) {
                dataList = ordersDataList;
                _selectedDay = null;
              } else if (_selectedIndex == 1) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Коммуналка').toList();
                _selectedDay = null;
              } else if (_selectedIndex == 2) {
                dataList = ordersDataList
                    .where(
                        (element) => element!.expenseCategory == 'Образование')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 3) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Досуг')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 4) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Продукты')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 5) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Питомцы')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 6) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Хозтовары')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 7) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Сырье')
                    .toList();
                _selectedDay = null;
              } else if (_selectedIndex == 8) {
                dataList = ordersDataList
                    .where((element) => element!.expenseCategory == 'Другое')
                    .toList();
                _selectedDay = null;
              }
              for (var element in ordersDataList) {
                DateTime milliseconds =
                    DateTime.fromMillisecondsSinceEpoch(element!.addedAt);

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
                dataList = ordersDataList
                    .where((elem) =>
                        DateTime.fromMillisecondsSinceEpoch(elem!.addedAt)
                            .day == _today.day)
                    .toList();
              }

              double total = 0.0;
              List<double> totalsList = dataList.map((e) => e!.expenseSum).toList();

              if (totalsList.isNotEmpty) {
                total = totalsList.reduce((value, element) => value + element);
              }

              return Column(
                children: [
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
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          shape: BoxShape.circle,),
                    ),
                    onDaySelected: _onDaySelected,
                    onPageChanged: (focusedDay) {
                      _today = focusedDay;
                    },
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
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
                        return null;
                      },
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 33,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
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
                  const Divider(),
                  RichSpanText(
                      spanText: SpanTextModel(
                          title: '',
                          data: total.toString(),
                          postTitle: ' KGS')),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      itemCount: dataList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichSpanText(
                                          spanText: SpanTextModel(
                                              title: 'Категория: ',
                                              data:
                                                  dataList[index]!.expenseCategory,
                                              postTitle: '')),
                                      RichSpanText(
                                          spanText: SpanTextModel(
                                              title: 'Назначение: ',
                                              data: dataList[index]!.expense,
                                              postTitle: '')),
                                      RichSpanText(
                                          spanText: SpanTextModel(
                                              title: 'Сумма: ',
                                              data: dataList[index]!
                                                  .expenseSum
                                                  .toString(),
                                              postTitle: '')),
                                      RichSpanText(
                                          spanText: SpanTextModel(
                                              title: 'Дата: ',
                                              data: Utils.dateTimeParse(
                                                  milliseconds:
                                                      dataList[index]!.addedAt),
                                              postTitle: '')),
                                      RichSpanText(
                                          spanText: SpanTextModel(
                                              title: 'Описание: ',
                                              data: dataList[index]!
                                                  .expenseDescription
                                                  .toString(),
                                              postTitle: '')),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await DataBaseHelper.deleteExpense(
                                            expenseModel: dataList[index]!)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                              subtitle: const Text(''),
                              horizontalTitleGap: 12.0,
                              onTap: () {},
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigation()
              .navigateToCreateExpenseScreen(context)
              .then((value) {
            setState(() {});
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
