import 'package:flutter/material.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';
import 'package:forleha/widgets/rich_text.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';
  final CustomerModel customerModel;
  const HomeScreen({super.key, required this.customerModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int bottomBarSelectedIndex = 0;
  CustomerModel? customerModel;


  @override
  void initState() {
    customerModel = widget.customerModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customerModel!.customerName.isNotEmpty ? Text(customerModel!.customerName) : const Text('Мониторинг'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: customerModel!.id == 0 ? DataBaseHelper.getOrders() : DataBaseHelper.getOrdersByCustomerId(customerId: customerModel!.id),
        builder: (context, AsyncSnapshot<List<OrderModel?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            List<OrderModel?>? ordersDataList = snapshot.data;
            List<OrderModel?> dataList = [];
            if(ordersDataList != null && ordersDataList.isNotEmpty){

              if(bottomBarSelectedIndex == 0){

                dataList = ordersDataList.where((element) => element!.orderStatus == 0).toList();

              }
              else if(bottomBarSelectedIndex == 1){

                dataList = ordersDataList.where((element) => element!.orderStatus == 1).toList();
              }
              else if(bottomBarSelectedIndex == 2){

                dataList = ordersDataList.where((element) => element!.orderStatus == 2).toList();
              }
              else if(bottomBarSelectedIndex == 3){

                dataList = ordersDataList.where((element) => element!.orderStatus == 3).toList();
              }

              // if (dataList != null && dataList.isNotEmpty) {
              //   double total = 0.0;
              //   List<double> totalsList = dataList.map((e) => e!.totalSum).toList();
              //
              //   if(totalsList.isNotEmpty){
              //
              //     total = totalsList.reduce((value, element) => value + element);
              //   }

              double total = 0.0;
              List<double> totalsList = dataList.map((e) => e!.totalSum).toList();

              if (totalsList.isNotEmpty) {
                total = totalsList.reduce((value, element) => value + element);
              }


              return Column(
                children: [
                  RichSpanText(spanText: SpanTextModel(title: '', data: Utils.numberParse(value: total), postTitle: '')),
                  const Divider(),
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    itemCount: dataList.length,
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
                                    //RichSpanText(spanText: SpanTextModel(title:'Заказчик: ', data: dataList[index]!.customerName, postTitle: '')),
                                    //RichSpanText(spanText: SpanTextModel(title:'Телефон: ', data: dataList[index]!.customerPhone.toString(), postTitle: '')),
                                    RichSpanText(spanText: SpanTextModel(title:'Сумма: ', data: Utils.numberParse(value: dataList[index]!.totalSum), postTitle: '')),
                                    RichSpanText(spanText: SpanTextModel(title:'Дата заказа: ', data: Utils.dateTimeParse(milliseconds: dataList[index]!.addedAt), postTitle: '')),
                                    RichSpanText(spanText: SpanTextModel(title:'Дата оплаты: ', data: Utils.dateTimeParse(milliseconds: dataList[index]!.acceptDate), postTitle: '')),
                                    //RichSpanText(spanText: SpanTextModel(title:'Статус: ', data: dataList[index]!.orderStatus.toString(), postTitle: '')),
                                    // ElevatedButton(child: const Text('Установить статус'),
                                    //   onPressed: () async {
                                    //     // await _addStatusDialog(orderModel: dataList[index]!).then((value) {
                                    //     //   setState(() {});
                                    //     // });
                                    //   }, ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: const Text(''),
                            horizontalTitleGap: 12.0,
                            onTap: (){
                              Navigation.navigateToOrderPositionsScreen(context, dataList[index]!);
                            },
                          ),
                          const Divider(),
                        ],
                      );

                    },
                    shrinkWrap: true,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: bottomBarSelectedIndex,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        onTap: (int index) {
          setState(() {
            bottomBarSelectedIndex = index;
          });

        },
        items: _bottomNavItems(context: context),

      ),
    );
  }

  Future<void> _addStatusDialog({required OrderModel orderModel}) async {
    String reason = '';
    double qty = 0;
    double amount = 0;
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
                    if(value == 'Заказ отгружен'){
                      newOrderStatus = 1;
                    }
                    else if(value == 'Заказ оплачен'){
                      newOrderStatus = 2;
                    }
                    setState(() {});
                  },
                  dropdownMenuEntries: [
                    'Заказ отгружен',
                    'Заказ оплачен',
                  ].map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () async {

                    DataBaseHelper.updateOrderStatus(
                        orderId: orderModel.id,
                        status: newOrderStatus).then((value) {
                          Navigator.pop(context);
                    });


                  },
                  child: const Text('Установиить'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () async {},
                  child: const Text('Удалить заказ'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Отменить'),
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }



}

List<BottomNavigationBarItem> _bottomNavItems({
  required BuildContext context,
}){

  return <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.timer_sharp,
          color: Theme.of(context).primaryColor,
        ),
        icon: const Icon(
          Icons.timer_sharp,
          color: Colors.grey,
        ),
        label: 'Принято'),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.done,
          color: Theme.of(context).primaryColor,
        ),
        icon: const Icon(
          Icons.done,
          color: Colors.grey,
        ),
        label: 'Отгружено'),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.done_all,
          color: Theme.of(context).primaryColor,
        ),
        icon: const Icon(
          Icons.done_all,
          color: Colors.grey,
        ),
        label: 'Закрыто'),
  ];
}


