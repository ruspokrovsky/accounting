import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:forleha/models/expense_model.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';

class CreateExpenseScreen extends StatefulWidget {
  static const String routeName = 'createExpenseScreen';

  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {

  TextEditingController expenseController = TextEditingController();
  TextEditingController expenseSumController = TextEditingController();
  TextEditingController expenseDescriptionController = TextEditingController();
  String expenseCategory = '';
  int acceptDate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Добавить расход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16,),
                  DropdownMenu<String>(
                    width: MediaQuery.of(context).size.width / 1.2,
                    label: const Text('Категория расхода'),
                    onSelected: (String? value) {

                      setState(() {
                        expenseCategory = value!;
                      });
                    },
                    dropdownMenuEntries: [
                      'Коммуналка',
                      'Образование',
                      'Досуг',
                      'Продукты',
                      'Питомцы',
                      'Хозтовары',
                      'Сырье',
                      'Другое',
                    ].map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                        leadingIcon: CircleAvatar(
                            radius: 10,
                            backgroundColor:
                            (value == 'Заказ принят')
                                ?
                            Colors.deepOrangeAccent
                                :
                            (value == 'Заказ отгружен')
                                ?
                            Colors.purpleAccent
                                :
                            (value == 'Заказ оплачен')
                                ?
                            Colors.greenAccent
                                :
                            Colors.grey



                        )
                        ,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 36,),
                  TextField(
                    controller: expenseController,
                    decoration: InputDecoration(
                      labelText: 'Наименование расхода',

                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: expenseSumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Сумма расхода',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  ElevatedButton(onPressed: (){
                    DatePickerBdaya.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2024, 01, 01, 00, 00),
                      maxTime: DateTime(2035, 01, 01, 00, 00),
                      onChanged: (date) {},
                      onConfirm: (date) {
                        setState((){
                          acceptDate = date.millisecondsSinceEpoch;
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
                  }, child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(
                              'Дата: ${Utils.dateTimeParse(milliseconds:
                              acceptDate == 0 ? DateTime.now().millisecondsSinceEpoch : acceptDate)}')))),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: expenseDescriptionController,
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Описание',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text('Сохранить'),
                        onPressed: (){
                          DataBaseHelper.addExpense(
                              ExpenseModel(
                                  id: 0,
                                  expense: expenseController.text.trim(),
                                  expenseCategory: expenseCategory,
                                  expenseSum: double.parse(expenseSumController.text.trim()),
                                  expenseDescription: expenseDescriptionController.text.trim(),
                                  addedAt: acceptDate == 0 ? DateTime.now().millisecondsSinceEpoch : acceptDate,
                              )).then((value) {
                            Navigator.pop(context);
                          });
                        },),
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

}
