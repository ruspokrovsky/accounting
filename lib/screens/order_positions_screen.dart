import 'package:flutter/material.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderPositionsScreen extends StatefulWidget {
  static const String routeName = 'orderPositionsScreen';
  final OrderModel orderData;
  const OrderPositionsScreen({super.key, required this.orderData});

  @override
  State<OrderPositionsScreen> createState() => _OrderPositionsScreenState();
}

class _OrderPositionsScreenState extends State<OrderPositionsScreen> {

  OrderModel? orderData;
  double cartQty = 0;

  @override
  void initState() {
    orderData = widget.orderData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseHelper.getOrderPositions(args: orderData!),
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
                preferredSize: const Size.fromHeight(100.0),
                child: AppBar(
                  toolbarHeight: 100,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichSpanText(spanText: SpanTextModel(title:'', data: orderData!.customerName, postTitle: '')),
                      //RichSpanText(spanText: SpanTextModel(title:'Всего позиций: ', data: '${dataList.length}', postTitle: '')),
                      RichSpanText(spanText: SpanTextModel(title:'', data: '$total', postTitle: '')),
                      //RichSpanText(spanText: SpanTextModel(title:'Дата доставки: ', data: '', postTitle: '')),
                    ],
                  ),

                  actions: [
                    PopupMenuButton(
                      itemBuilder: (context) => [

                        const PopupMenuItem(
                            value: 0,
                            child: Icon(Icons.call)),
                        const PopupMenuItem(
                            value: 1,
                            child: Icon(Icons.bar_chart)),

                      ],
                      onSelected: (int ind){
                        if(ind == 0){
                          launchUrlString('tel://${orderData!.customerPhone}');
                        }
                        else if(ind == 1){
                          Navigation.navigateToHomeScreen(context, CustomerModel(
                              id: orderData!.customerId,
                              customerName: orderData!.customerName,
                              customerPhone: orderData!.customerPhone,
                              customerBirthday: 0,
                              addedAt: 0));
                        }

                      },
                    ),
                  ],
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
                            IconButton(
                                onPressed: () async {

                                  await _addToCartDialog(positionData: dataList[index]!).then((value) {
                                    setState(() {});
                                  });

                                },
                                icon: const Icon(Icons.edit)),

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
              floatingActionButton: FloatingActionButton(
                onPressed: () async {

                  await Navigation().navigateToPositionsScreen(context, orderData!).then((value) {
                    setState(() {});
                  });
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
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
    );
  }

  Future<void> _addToCartDialog({required CartModel positionData}) async {
    String reason = '';
    double qty = positionData.positionQty;
    double amount = 0;
    int acceptDate = 0;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  RichSpanText(spanText: SpanTextModel(title: 'наим: ', data: positionData.positionName, postTitle:'')),
                  RichSpanText(spanText: SpanTextModel(title: 'цена: ', data: positionData.positionPrice.toString(), postTitle:'')),
                  RichSpanText(spanText: SpanTextModel(title: 'колич: ', data: positionData.positionQty.toString(), postTitle:'')),
                  RichSpanText(spanText: SpanTextModel(title: 'сумма: ', data: positionData.positionAmount.toString(), postTitle:'')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (qty > 0) {
                              setState(() {
                                qty--;
                                positionData.positionQty = qty;
                                amount = (qty * positionData.positionPrice);
                                positionData.positionAmount = amount;
                                cartQty = qty;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.remove,
                            size: 36.0,
                          )),
                      Text(
                        '$qty',
                        style: const TextStyle(
                            fontSize: 23.0, color: Colors.deepOrange),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              qty++;
                              positionData.positionQty = qty;
                              amount = (qty * positionData.positionPrice);
                              positionData.positionAmount = amount;
                              cartQty = qty;
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 36.0,
                          )),
                    ],
                  ),
                ],
              ),

              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () async {
                    if(qty > 0 ){
                      await DataBaseHelper.updateOrderedPosition(

                          CartModel(
                        id: positionData.id,
                        customerId: positionData.customerId,
                        positionId: positionData.positionId,
                        positionName: positionData.positionName,
                        positionPrice: positionData.positionPrice,
                        positionQty: positionData.positionQty,
                        positionAmount: positionData.positionAmount,
                        orderId: 0,))
                          .then((value) {})
                          .then((value) => Navigator.pop(context));
                    }

                  },
                  child: const Text('Изменить'),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Удалить'),
                  onPressed: () async {
                    await DataBaseHelper.deleteOrderedPosition(positionData: CartModel(
                      id: positionData.id,
                      customerId: 0,
                      positionId: 0,
                      positionName: '',
                      positionPrice: 0,
                      positionQty: 0,
                      positionAmount: 0,
                      orderId: 0,))
                        .then((value) {Navigator.pop(context);});
                  },
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
