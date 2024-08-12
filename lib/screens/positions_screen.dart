import 'package:flutter/material.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/position_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/widgets/rich_text.dart';

class PositionsScreen extends StatefulWidget {
  static const String routeName = 'positionsScreen';
  final OrderModel orderData ;

  const PositionsScreen({super.key, required this.orderData,});

  @override
  State<PositionsScreen> createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  CustomerModel? customerData;
  OrderModel? orderData;

  double cartQty = 0;

  @override
  void initState() {
    orderData = widget.orderData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Продукция'),),
      body: FutureBuilder(
        future: DataBaseHelper.getAllPosition(),
        builder: (context, AsyncSnapshot<List<PositionModel>> snapshot) {
          List<PositionModel> positionDataList = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            positionDataList = snapshot.data!;
            if (positionDataList.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: positionDataList.length,
                  itemBuilder: (BuildContext context, int index) {

                    return Container(
                      margin: const EdgeInsets.only(top: 6.0),
                      decoration: BoxDecoration(
                        border: Border.all(

                          color: positionDataList[index].isSelected!
                              ? Colors.deepOrangeAccent
                              : Theme.of(context).primaryColor,

                          width: positionDataList[index].isSelected!
                              ? 3
                              : 1,),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            positionDataList[index].positionName[0],
                            style: TextStyle(
                              fontSize: 23.0,
                              color: positionDataList[index].isSelected!
                                  ? Colors.deepOrange
                                  : Colors.green,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichSpanText(
                                spanText: SpanTextModel(
                                    title: 'Наим.: ',
                                    data: positionDataList[index].positionName,
                                    postTitle: '')),
                            RichSpanText(
                                spanText: SpanTextModel(
                                    title: 'Цена: ',
                                    data: positionDataList[index]
                                        .positionPrice
                                        .toString(),
                                    postTitle: ' KGS')),
                          ],
                        ),
                        trailing: IconButton(icon: const Icon(Icons.delete),
                          onPressed: (){
                            DataBaseHelper.deletePosition(positionDataList[index]).then((value) {
                              setState(() {});
                            });

                          }, ),
                        horizontalTitleGap: 12.0,
                        onTap: () async {

                          if(orderData!.id != 0){

                            await _addToCartDialog(
                                orderData: orderData!,
                                positionData: positionDataList[index]).then((value) => Navigator.pop(context));

                          }
                        },
                      ),
                    );
                  },
                  shrinkWrap: true,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          await Navigation().navigateToCreatePositionScreen(context).then((value) {
            setState(() {});
          });

        },
        tooltip: 'Позвонить',
        child: const Icon(Icons.add),
      ),
    );
  }


  Future<void> _addToCartDialog({required PositionModel positionData, required OrderModel orderData}) async {
    String reason = '';
    double qty = 0;
    double amount = 0;
    int acceptDate = 0;
    PositionModel positionModel;
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
                  Text(positionData.positionName),
                  Text(positionData.positionPrice.toString()),
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
                                amount = (qty * positionData.positionPrice);
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
                              amount = (qty * positionData.positionPrice);
                              cartQty = qty;
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 36.0,
                          )),
                    ],
                  ),
                  Text(
                    '$amount',
                    style: const TextStyle(
                        fontSize: 23.0, color: Colors.deepOrange),
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
                      await DataBaseHelper.addOrderedPosition(CartModel(
                        id: 0,
                        customerId: orderData.customerId,
                        positionId: positionData.id,
                        positionName: positionData.positionName,
                        positionPrice: positionData.positionPrice,
                        positionQty: qty,
                        positionAmount: amount,
                        orderId: orderData.id,))
                          .then((value) => Navigator.pop(context));
                    }

                  },
                  child: const Text('Добавить'),
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
