import 'package:flutter/material.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/position_model.dart';
import 'package:forleha/models/span_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/widgets/rich_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AddToCartScreen extends StatefulWidget {
  static const String routeName = 'addToCartScreen';

  final CustomerModel customerData;

  const AddToCartScreen({super.key, required this.customerData});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  CustomerModel? customerData;

  double cartQty = 0;

  @override
  void initState() {
    customerData = widget.customerData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(customerData!.customerName,style: const TextStyle(fontSize: 20),),
            Text(customerData!.customerPhone,style: const TextStyle(fontSize: 18),),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                launchUrlString('tel://${customerData!.customerPhone}');
              },
              icon: const Icon(Icons.call))
        ],
      ),
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
                    List<CartModel?>? cartDataList = snapshot.data;
                    if (cartDataList != null && cartDataList.isNotEmpty) {
                      double total = 0;
                      List<double> amountsList = cartDataList.map((e) => e!.positionAmount).toList();
                      List<int> selectedIdList = cartDataList.map((e) => e!.positionId).toList();
                      if (amountsList.isNotEmpty) {
                        total = amountsList.reduce((value, element) => value + element);
                      }
                      if (selectedIdList.isNotEmpty) {
                        for (var element in positionDataList) {
                          if(selectedIdList.contains(element.id)){
                            element.isSelected = true;
                            element.qtyForCart = cartQty;
                          }
                        }
                      }
                    }
                  }

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
                            horizontalTitleGap: 12.0,
                            onTap: () async {

                              if(!positionDataList[index].isSelected!){
                                await _addToCartDialog(
                                  positionData: positionDataList[index],
                                ).then((value) {
                                  setState(() {});
                                });
                              }

                            },
                          ),
                        );
                      },
                      shrinkWrap: true,
                    ),
                  );
                },
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

          await Navigation().navigateToCartScreen(context, customerData!).then((value) {

            if(value == 'cartSuccess'){
              Navigator.pop(context);
            }
            else {
              setState(() {});
            }
          });

        },
        tooltip: 'Позвонить',
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }

  Future<void> _addToCartDialog({required PositionModel positionData}) async {
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

                  // Container(
                  //   padding: const EdgeInsets.all(3.0),
                  //   child: DropdownMenu<String>(
                  //     //width:MediaQuery.of(context).size.width - 16,
                  //     label: const Text('Укажите причину отмены'),
                  //     onSelected: (String? value) {
                  //       setState(() {
                  //         reason = value!;
                  //       });
                  //     },
                  //     dropdownMenuEntries: [
                  //       'Не соответствует заявленному',
                  //       'Не своевременная доставка',
                  //       'Просрочено',
                  //       'Не учтено описание',
                  //     ].map<DropdownMenuEntry<String>>((String value) {
                  //       return DropdownMenuEntry<String>(
                  //           value: value, label: value);
                  //     }).toList(),
                  //   ),
                  // ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () async {
                        if(qty > 0 ){
                          await DataBaseHelper.addPositionToCart(CartModel(
                            id: 0,
                            customerId: customerData!.id,
                            positionId: positionData.id,
                            positionName: positionData.positionName,
                            positionPrice: positionData.positionPrice,
                            positionQty: qty,
                            positionAmount: amount,
                            orderId: 0,))
                              .then((value) {})
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
