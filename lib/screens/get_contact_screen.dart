import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/widgets/search_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class GetContactScreen extends StatefulWidget {
  static const String routeName = 'getContactScreen';

  const GetContactScreen({super.key});

  @override
  State<GetContactScreen> createState() => _GetContactScreenState();
}

class _GetContactScreenState extends State<GetContactScreen> {
  List<Contact> contacts1 = [];
  List<Contact> contacts = [];
  bool isLoading = true;
  String query = '';

  void fetchContacts() async {
    contacts1 = await ContactsService.getContacts();

    contacts = contacts1.where((element) => element.displayName != null && element.phones!.isNotEmpty).toList();

    setState(() {
      isLoading = false;
    });
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  @override
  void initState() {
    getContactPermission();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearch(categoryPressed: (){}, onTapJoinPosition: (){}, onTapCart: (){}),
      ),
      body: contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                String phone = 'номер не найден';
                String name = 'имя не найдено';
                String avaChar = '=(';

                if (contacts[index].phones!.isNotEmpty) {
                  phone = contacts[index].phones![0].value.toString();
                }
                if (contacts[index].displayName != null) {
                  name = contacts[index].displayName.toString();
                  avaChar = name[0];
                }

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(avaChar,
                      style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text(phone,),
                  horizontalTitleGap: 12.0,
                  onTap: () {

                    Navigation().navigateToCreateCustomerScreen(context, CustomerModel(
                      id: 0,
                      customerName: contacts[index].displayName!,
                      customerPhone: contacts[index].phones![0].value!,
                      customerBirthday: 0,
                      addedAt: 0,
                    ));
                  },
                );
              },
              shrinkWrap: true,
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
    final books = contacts.where((book) {
      final titleLower = book.displayName!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    if (query.isNotEmpty) {
      contacts = books;
    } else {
      setState(() {
        getContactPermission();
        //contacts = [];
        //getAllPosition();
      });
    }
    setState(() {
      this.query = query;
    });
  }



}
