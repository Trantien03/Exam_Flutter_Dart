import 'package:flutter/material.dart';

import 'add_order_screen.dart';

class OrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Giả lập 10 đơn hàng
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Dish $index'),
            subtitle: Text('Votes: 5, Notes: Good, Quantity: 2'),
          );
        },
      ),
    );
  }
}