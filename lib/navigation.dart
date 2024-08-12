import 'package:flutter/cupertino.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/screens/add_to_cart_screen.dart';
import 'package:forleha/screens/all_ordered_positions_screen.dart';
import 'package:forleha/screens/bank_screen.dart';
import 'package:forleha/screens/cart_screen.dart';
import 'package:forleha/screens/create_admission_screen.dart';
import 'package:forleha/screens/create_avans_screen.dart';
import 'package:forleha/screens/create_customer_screen.dart';
import 'package:forleha/screens/create_expense_screen.dart';
import 'package:forleha/screens/create_position_screen.dart';
import 'package:forleha/screens/customers_screen.dart';
import 'package:forleha/screens/expense_screen.dart';
import 'package:forleha/screens/get_contact_screen.dart';
import 'package:forleha/screens/home_page.dart';
import 'package:forleha/screens/home_screen.dart';
import 'package:forleha/screens/order_positions_screen.dart';
import 'package:forleha/screens/positions_screen.dart';

class Navigation{

  Future navigateToPositionsScreen(BuildContext context, OrderModel orderData) async {
    return await Navigator.pushNamed(context, PositionsScreen.routeName, arguments: orderData);
  }

  Future navigateToAddToCartScreen(BuildContext context, CustomerModel customerData) async {
    return await Navigator.pushNamed(context, AddToCartScreen.routeName, arguments: customerData);
  }

  Future navigateToCreatePositionScreen(BuildContext context) async {
    return await Navigator.pushNamed(context, CreatePositionScreen.routeName);
  }

  Future navigateToCreateExpenseScreen(BuildContext context) async {
    return await Navigator.pushNamed(context, CreateExpenseScreen.routeName);
  }

  Future navigateToCreateAdmissionScreen(BuildContext context) async {
    return await Navigator.pushNamed(context, CreateAdmissionScreen.routeName);
  }

  Future navigateToCreateAvansScreen(BuildContext context) async {
    return await Navigator.pushNamed(context, CreateAvansScreen.routeName);
  }

  static void navigateToHomeScreen(BuildContext context, CustomerModel args) {
    Navigator.pushNamed(context, HomeScreen.routeName, arguments: args);
  }

  Future navigateToCreateCustomerScreen(BuildContext context, CustomerModel args) async {
    return await Navigator.pushNamed(context, CreateCustomerScreen.routeName, arguments: args);
  }

  Future navigateToCustomersScreen(BuildContext context) async {
   return await Navigator.pushNamed(context, CustomersScreen.routeName);
  }

  Future navigateToCartScreen(BuildContext context, CustomerModel customerData) async {
    return await Navigator.pushNamed(context, CartScreen.routeName, arguments: customerData);
  }

  static void navigateToOrderPositionsScreen(BuildContext context, OrderModel orderData) {
    Navigator.pushNamed(context, OrderPositionsScreen.routeName, arguments: orderData);
  }

  static void navigateToAllOrderedPositionsScreen(BuildContext context, CustomerModel customerData) {
    Navigator.pushNamed(context, AllOrderedPositionsScreen.routeName, arguments: customerData);
  }

  static void navigateToExpenseScreen(BuildContext context,) {
    Navigator.pushNamed(context, ExpenseScreen.routeName,);
  }

  static void navigateToBankScreen(BuildContext context,) {
    Navigator.pushNamed(context, BankScreen.routeName,);
  }

  Future navigateToGetContactScreen(BuildContext context) async {
    return await Navigator.pushNamed(context, GetContactScreen.routeName);
  }

  Future navigateToHomePage(BuildContext context) async {
    return await Navigator.pushNamed(context, HomePage.routeName);
  }

}