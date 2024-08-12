import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:forleha/models/bank_model.dart';
import 'package:forleha/services/db_helper.dart';
import 'package:forleha/utils.dart';

class CreateAdmissionScreen extends StatefulWidget {
  static const String routeName = 'createAdmissionScreen';

  const CreateAdmissionScreen({super.key});

  @override
  State<CreateAdmissionScreen> createState() => _CreateAdmissionScreenState();
}

class _CreateAdmissionScreenState extends State<CreateAdmissionScreen> {

  TextEditingController admissionController = TextEditingController();
  TextEditingController admissionSumController = TextEditingController();
  TextEditingController admissionDescriptionController = TextEditingController();
  String expenseCategory = '';
  int acceptDate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Оформить поступление'),
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
                    controller: admissionController,
                    decoration: InputDecoration(
                      labelText: 'Наименование поступления',

                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: admissionSumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Сумма поступления',
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
                    controller: admissionDescriptionController,
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
                          if(admissionSumController.text.isNotEmpty){
                            DataBaseHelper.addAdmission(
                              BankModel(
                                  id: 0,
                                  admission: admissionController.text.trim(),
                                  expense: '',
                                  admissionSum: double.parse(admissionSumController.text.trim()),
                                  expenseSum: 0.0,
                                  admissionDescription: admissionDescriptionController.text.trim(),
                                  expenseDescription: '',
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
