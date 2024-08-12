import 'package:flutter/material.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/widgets/search_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomersScreen extends StatefulWidget {
  static const String routeName = 'customersScreen';
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<CustomerModel?> dataList = [];
  List<CustomerModel?> dataList2 = [];
  String query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: buildSearch(categoryPressed: (){}, onTapJoinPosition: (){}, onTapCart: (){}),

      ),
      body: FutureBuilder(
        future: DataBaseHelper.getAllCustomer(),
        builder: (context, AsyncSnapshot<List<CustomerModel?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            dataList2 = snapshot.data!;

            if(query.isEmpty){
              dataList = dataList2;
            }

            if (dataList.isNotEmpty) {
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    // leading: CircleAvatar(
                    //   child:  Text(
                    //     dataList[index]!.customerName[0],
                    //     style: const TextStyle(
                    //       fontSize: 23.0,
                    //       color: Colors.deepOrange,
                    //       fontFamily: "Poppins",
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    title: Text(dataList[index]!.customerName,),
                    //subtitle: Text(dataList[index]!.customerPhone,),
                    trailing: PopupMenuButton(
                        itemBuilder: (context) => [

                          const PopupMenuItem(
                            value: 0,
                              child: Icon(Icons.call)),
                          const PopupMenuItem(
                              value: 1,
                              child: Icon(Icons.edit)),
                          const PopupMenuItem(
                              value: 2,
                              child: Icon(Icons.bar_chart)),
                          const PopupMenuItem(
                              value: 3,
                              child: Icon(Icons.join_inner)),
                        ],
                      onSelected: (int ind){
                          if(ind == 0){
                            launchUrlString('tel://${dataList[index]!.customerPhone}');
                          }
                          else if(ind == 1){
                                  Navigation().navigateToCreateCustomerScreen(context, CustomerModel(
                                      id: dataList[index]!.id,
                                      customerName: dataList[index]!.customerName,
                                      customerPhone: dataList[index]!.customerPhone,
                                      customerBirthday: 0,
                                      addedAt: 0)).then((value) {
                                        setState(() {});
                                  });
                          }
                          else if(ind == 2){
                            Navigation.navigateToHomeScreen(context, dataList[index]!);
                          }
                          else if(ind == 3){
                            Navigation.navigateToAllOrderedPositionsScreen(context, dataList[index]!);
                          }

                    },
                    ),
                    horizontalTitleGap: 12.0,
                    onTap: () async {
                      await Navigation().navigateToAddToCartScreen(context, dataList[index]!).then((value) {
                        Navigator.pop(context);
                      });
                    },
                  );

                },
                shrinkWrap: true,
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

          await Navigation().navigateToCreateCustomerScreen(context, CustomerModel(
              id: 0,
              customerName: '',
              customerPhone: '',
              customerBirthday: 0,
              addedAt: 0)).then((value) {
            setState(() {});
          });

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }


  Widget buildSearch({
    required VoidCallback categoryPressed,
    required VoidCallback onTapJoinPosition,
    required VoidCallback onTapCart,
  }) =>
      SearchWidget(
        text: 'query',
        hintText: 'Поиск',
        onChanged: searchBook,
        isAdditionalBtn: false,
      );

  void searchBook(String query) {
    final books = dataList2.where((book) {
      final titleLower = book!.customerName.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    if (query.isNotEmpty) {
      dataList = books;
    } else {
      setState(() {
        dataList = dataList2;
      });
    }
    setState(() {
      this.query = query;
    });
  }

}
