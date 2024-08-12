import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:forleha/models/bank_model.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';

class CreateAvansScreen extends StatefulWidget {
  static const String routeName = 'createAvansScreen';

  const CreateAvansScreen({super.key});

  @override
  State<CreateAvansScreen> createState() => _CreateAvansScreenState();
}

class _CreateAvansScreenState extends State<CreateAvansScreen> {

  TextEditingController avansController = TextEditingController();
  TextEditingController avansSumController = TextEditingController();
  TextEditingController avansDescriptionController = TextEditingController();
  String expenseCategory = '';
  int acceptDate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Оформить аванс'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 36,),
                  TextField(
                    controller: avansController,
                    decoration: InputDecoration(
                      labelText: 'Наименование аванса',

                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: avansSumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Сумма аванса',
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
                    controller: avansDescriptionController,
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
                          if(avansSumController.text.isNotEmpty){
                            DataBaseHelper.addAdmission(
                              BankModel(
                                  id: 0,
                                  admission: '',
                                  expense: avansController.text.trim(),
                                  admissionSum: 0.0,
                                  expenseSum: double.parse(avansSumController.text.trim()),
                                  admissionDescription: '',
                                  expenseDescription: avansDescriptionController.text.trim(),
                                  addedAt: acceptDate == 0 ? DateTime.now().millisecondsSinceEpoch : acceptDate,
                                  expAt: 0),).then((value) {
                              Navigator.pop(context);
                            });
                          }

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
