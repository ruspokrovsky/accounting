import 'package:flutter/material.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/services/db_helper.dart';

class CreateCustomerScreen extends StatefulWidget {
  static const String routeName = 'createCustomerScreen';

  final CustomerModel customerModel;

  const CreateCustomerScreen({super.key, required this.customerModel});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController customerDescriptionController = TextEditingController();
  int birthdayDate = 0;

  late CustomerModel customerData;


  @override
  void initState() {
    customerData = widget.customerModel;

    if(customerData.customerPhone.isNotEmpty){
      nameController.text = customerData.customerName;
      phoneController.text = customerData.customerPhone;
      birthdayDate = customerData.customerBirthday;


    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Добавить заказчика'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16,),
                  TextButton(
                    child: const Text('Добавить из контактов'),
                    onPressed: () async {
                    await Navigation().navigateToGetContactScreen(context).then((value) {
                      Navigator.pop(context);
                    });
                  },),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя заказчика',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Телефон',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 36,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text('Сохранить'),
                        onPressed: (){

                          if(nameController.text.isNotEmpty && phoneController.text.isNotEmpty){
                            if(customerData.id != 0){
                              DataBaseHelper.updateCustomer(customerData: CustomerModel(
                                  id: customerData.id,
                                  customerName: nameController.text.trim(),
                                  customerPhone: phoneController.text.trim(),
                                  customerBirthday: birthdayDate,
                                  addedAt: customerData.addedAt)).then((value) {
                                Navigator.pop(context);
                              });
                            }
                            else {
                              DataBaseHelper.addCustomer(
                                  CustomerModel(
                                      id: 0,
                                      customerName: nameController.text.trim(),
                                      customerPhone: phoneController.text.trim(),
                                      customerBirthday: birthdayDate,
                                      addedAt: DateTime.now().millisecondsSinceEpoch)).then((value) {
                                Navigator.pop(context);
                              });
                            }

                          }
                        },),

                      if(customerData.id != 0)
                        ElevatedButton(
                          child: const Text('Удалить'),
                          onPressed: () async {

                            await _deleteCustomerDialog(customerModel: CustomerModel(
                                id: customerData.id,
                                customerName: customerData.customerName,
                                customerPhone: customerData.customerPhone,
                                customerBirthday: 0,
                                addedAt: 0)).then((value) {
                              Navigator.pop(context);
                            });


                          }, )
                      else
                      ElevatedButton(
                        child: const Text('Назад'),
                        onPressed: (){
                          Navigator.pop(context);
                        }, ),
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<void> _deleteCustomerDialog({required CustomerModel customerModel}) async {
    String reason = '';
    double qty = 0;
    double amount = 0;
    int newOrderStatus = 0;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(
                builder: (context, setState) =>
                    AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      actionsPadding: EdgeInsets.zero,
                      contentPadding: const EdgeInsets.all(8.0),
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0))),
                      title: Column(
                        children: [
                          Text(customerModel.customerName),
                          Text(customerModel.customerPhone),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .labelLarge,
                          ),
                          onPressed: () async {
                            DataBaseHelper.deleteCustomer(
                              customerModel: customerModel,).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('Удалить'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .labelLarge,
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

