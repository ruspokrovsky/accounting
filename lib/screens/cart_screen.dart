import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = 'cartScreen';
  final CustomerModel costomerData;
  const CartScreen({super.key, required this.costomerData});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CustomerModel? costomerData;
  int addedDate = DateTime.now().millisecondsSinceEpoch;

  double updateQty = 0.0;
  double updateAmount = 0.0;

  @override
  void initState() {
    costomerData = widget.costomerData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseHelper.getCart(),
      builder: (context, AsyncSnapshot<List<CartModel?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          List<CartModel?>? dataList = snapshot.data;
          if (dataList != null && dataList.isNotEmpty) {
            double total = 0.0;
            List<double> amountsList = dataList.map((e) => e!.positionAmount).toList();

            if(amountsList.isNotEmpty){

              total = amountsList.reduce((value, element) => value + element);
            }


            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(120.0),
                child: AppBar(
                  toolbarHeight: 120.0,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichSpanText(spanText: SpanTextModel(title:'', data: costomerData!.customerName, postTitle: '')),
                      GestureDetector(
                        onTap: (){
                          launchUrlString('tel://${costomerData!.customerPhone}');
                        },
                          child: RichSpanText(spanText: SpanTextModel(title:'', data: costomerData!.customerPhone, postTitle: ''))),
                      //RichSpanText(spanText: SpanTextModel(title:'Всего позиций: ', data: dataList.length.toString(), postTitle: '')),
                      RichSpanText(spanText: SpanTextModel(title:'', data: '$total', postTitle: ' KGS')),
                      RichSpanText(spanText: SpanTextModel(title:'', data: Utils.dateTimeParse(milliseconds: addedDate), postTitle: '')),
                    ],
                  ),
                ),
              ),
              body: ListView.builder(
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

                                RichSpanText(spanText: SpanTextModel(title:'Наименование: ', data: dataList[index]!.positionName, postTitle: '')),
                                RichSpanText(spanText: SpanTextModel(title:'Цена: ', data: dataList[index]!.positionPrice.toString(), postTitle: ' KGS')),
                                RichSpanText(spanText: SpanTextModel(title:'Количество: ', data: dataList[index]!.positionQty.toString(), postTitle: ' шт')),
                                RichSpanText(spanText: SpanTextModel(title:'Сумма: ', data: dataList[index]!.positionAmount.toString(), postTitle: ' KGS')),

                                ],
                            ),
                            IconButton(icon: const Icon(Icons.delete),
                              onPressed: (){
                                DataBaseHelper.deleteCartPosition(dataList[index]!).then((value) {
                                  setState(() {});
                                });

                              }, ),
                          ],
                        ),
                        subtitle: const Text(''),
                        horizontalTitleGap: 12.0,

                        onTap: (){},
                      ),
                      const Divider(),
                    ],
                  );

                },
                shrinkWrap: true,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                width: MediaQuery.of(context).size.width,
                height: 60.0,

                decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(child: const Text('Заказать'),
                      onPressed: () async {

                      await DataBaseHelper.addOrder(OrderModel(
                          id: 0,
                          customerId: costomerData!.id,
                          customerName: costomerData!.customerName,
                          customerPhone: costomerData!.customerPhone,
                          addedAt: addedDate,
                          // addedAt: DateTime.now().millisecondsSinceEpoch,
                          acceptDate: 0,
                          shipmentDate: 0,
                          orderStatus: 0,
                          invoice: 1,
                          totalSum: total,
                      )).then((int orderIds) async {

                        print('orderIds------$orderIds');

                        for (var elem in dataList) {
                          elem!.orderId = orderIds;
                        }

                        await DataBaseHelper.addOrderPositions(dataList).then((value) {
                          print(value);
                        });

                      }).then((value) async{
                        await DataBaseHelper.clearCart().whenComplete(() => Navigator.pop(context,'cartSuccess'));
                      });
                      },),

                    ElevatedButton(onPressed: (){
                      DatePickerBdaya.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2024, 01, 01, 00, 00),
                        maxTime: DateTime(2035, 01, 01, 00, 00),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          setState((){
                            addedDate = date.millisecondsSinceEpoch;
                          });
                        },
                        locale: LocaleType.ru,
                        theme: DatePickerThemeBdaya(
                          headerColor: Theme.of(context).primaryColor,
                          //backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              //fontWeight: FontWeight.bold,
                              fontSize: 23.0),
                          cancelStyle: const TextStyle(color: Colors.white, fontSize: 16),
                          doneStyle: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }, child: const Text('Дата доставки')),


                    // ElevatedButton(onPressed: (){}, child: const Text('Очистить')),
                  ],
                ),

              ),
            );
          } else {
            return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Text('Нет данных'),
              ),
            );
          }
        } else {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text('Нет данных'),
            ),
          );
        }
      },
    );




  }
}
