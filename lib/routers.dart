import 'package:flutter/material.dart';
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

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {

    case PositionsScreen.routeName:
      OrderModel orderData = routeSettings.arguments as OrderModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  PositionsScreen(orderData: orderData));
    case AllOrderedPositionsScreen.routeName:
      CustomerModel customerData = routeSettings.arguments as CustomerModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  AllOrderedPositionsScreen(customerData: customerData,));

    case AddToCartScreen.routeName:
      CustomerModel customerData = routeSettings.arguments as CustomerModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => AddToCartScreen(customerData: customerData));

    case CreatePositionScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CreatePositionScreen());

    case CreateExpenseScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CreateExpenseScreen());

    case CreateAdmissionScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CreateAdmissionScreen());

    case CreateAvansScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CreateAvansScreen());

    case BankScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BankScreen());

    case HomeScreen.routeName:
      CustomerModel customerModel = routeSettings.arguments as CustomerModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => HomeScreen(customerModel: customerModel,));

    case CustomersScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CustomersScreen());

    case GetContactScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const GetContactScreen());

    case CartScreen.routeName:
      CustomerModel costomerData = routeSettings.arguments as CustomerModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => CartScreen(costomerData: costomerData));

    case OrderPositionsScreen.routeName:
      OrderModel orderData = routeSettings.arguments as OrderModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => OrderPositionsScreen(orderData: orderData));

    case ExpenseScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const ExpenseScreen());

    case CreateCustomerScreen.routeName:
      CustomerModel customerModel = routeSettings.arguments as CustomerModel;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => CreateCustomerScreen(customerModel: customerModel,));

    case HomePage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomePage());



    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text("Нет такой страницы"),
                ),
              ));
  }
}
