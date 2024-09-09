import 'package:flutter/material.dart';
import 'package:examflutterdart/config/database_helper.dart'; // Import lớp DatabaseHelper

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String dishName = '';
  int votes = 0;
  String notes = '';
  int quantity = 1;

  // Danh sách món ăn có sẵn
  List<String> availableDishes = ['Pizza', 'Burger', 'Pasta', 'Sushi'];
  String? selectedDish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Dish Name'),
                value: selectedDish,
                items: availableDishes
                    .map((dish) => DropdownMenuItem(
                  value: dish,
                  child: Text(dish),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDish = value!;
                    dishName = selectedDish!;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a dish' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Votes'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  votes = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter votes';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Votes must be a positive number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (value) {
                  notes = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  quantity = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: Text('Add Order'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Sử dụng 'backgroundColor'
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm xử lý khi nhấn nút 'Add Order'
  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Thêm đơn hàng vào Firebase và SQLite
        await DatabaseHelper().addOrder(dishName, votes, notes, quantity);

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order for $dishName added successfully!')),
        );

        // Quay lại trang trước sau khi thêm
        Navigator.pop(context);
      } catch (e) {
        // Hiển thị lỗi nếu xảy ra sự cố
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add order: $e')),
        );
      }
    }
  }

  // Hàm đặt lại form về trạng thái mặc định
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      selectedDish = null;
      dishName = '';
      votes = 0;
      notes = '';
      quantity = 1;
    });
  }
}
