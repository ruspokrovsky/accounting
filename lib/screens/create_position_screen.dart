import 'package:flutter/material.dart';
import 'package:forleha/models/position_model.dart';
import 'package:forleha/services/db_helper.dart';

class CreatePositionScreen extends StatefulWidget {
  static const String routeName = 'createPositionScreen';
  const CreatePositionScreen({super.key});

  @override
  State<CreatePositionScreen> createState() => _CreatePositionScreenState();
}

class _CreatePositionScreenState extends State<CreatePositionScreen> {

  TextEditingController positionNameController = TextEditingController();
  TextEditingController positionPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Добавить позицию'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16,),
              TextField(
                controller: positionNameController,
                decoration: InputDecoration(
                    labelText: 'Наименование (объем)',
                    labelStyle: Theme.of(context).textTheme.labelLarge,
                    contentPadding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(height: 16,),
              TextField(
                controller: positionPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Цена за еденицу',
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

                      DataBaseHelper.addPosition(
                          PositionModel(
                              id: 0,
                              positionName: positionNameController.text.trim(),
                              positionPrice: double.parse(positionPriceController.text.trim()),
                              addedAt: 0)).then((value) {
                                Navigator.pop(context);
                              });
                      },),

                  ElevatedButton(
                    child: const Text('Назад'),
                    onPressed: (){}, ),
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
