import 'package:flutter/material.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllOrderedPositionsScreen extends StatefulWidget {
  static const String routeName = 'allOrderedPositionsScreen';
  final CustomerModel customerData;
  const AllOrderedPositionsScreen({super.key, required this.customerData});

  @override
  State<AllOrderedPositionsScreen> createState() => _AllOrderedPositionsScreenState();
}

class _AllOrderedPositionsScreenState extends State<AllOrderedPositionsScreen> {

  CustomerModel? customerData;
  double cartQty = 0;

  @override
  void initState() {
    customerData = widget.customerData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseHelper.getAllOrderedPositions(args: customerData!),
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
                      GestureDetector(
                          child: RichSpanText(spanText: SpanTextModel(title:'', data: customerData!.customerName, postTitle: '')),
                      onTap: (){
                        launchUrlString('tel://${customerData!.customerPhone}');
                      },),
                      //RichSpanText(spanText: SpanTextModel(title:'Всего позиций: ', data: '${dataList.length}', postTitle: '')),
                      RichSpanText(spanText: SpanTextModel(title:'', data: '$total', postTitle: ' KGS')),
                      //RichSpanText(spanText: SpanTextModel(title:'Дата доставки: ', data: '', postTitle: '')),
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
                onPressed: () async {},
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


}
