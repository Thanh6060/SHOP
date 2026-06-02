
import 'package:flutter/material.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/shop/screens/order/widgets/orders_list.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true, title: Text("My Orders", style: Theme.of(context).textTheme.headlineSmall,),
      ),
      body: Padding(
          padding: UPadding.screenPadding,
        child: UOrdersListItem(),
      ),
    );
  }
}
