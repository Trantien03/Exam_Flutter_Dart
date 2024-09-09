import 'package:flutter/material.dart';
import 'order_list_screen.dart'; // Ensure these files exist
import 'add_order_screen.dart';  // Ensure these files exist
import '../color.dart'; // Custom color file

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome Head Chef',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: greenSwatch[900], // Background color of AppBar
        iconTheme: IconThemeData(
          color: Colors.blue, // Change the color of the hamburger icon
        ),
      ),
      drawer: Drawer(
        // Wrap ListView in a Container to set the background color
        child: Container(
          color: greenSwatch[500], // Set the background color for the entire ListView
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Custom Header to match uploaded design
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24, // Adjust the size as needed
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30, // Adjust icon size
                        color: greenSwatch[500], // Icon color matching theme
                      ),
                    ),
                    SizedBox(width: 12), // Space between icon and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Head Chef',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'headchef@gmail.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white), // Corrected icon color
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.white), // Corrected icon to match "Restaurants"
                title: Text(
                  'Restaurants',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.receipt, color: Colors.white), // Corrected icon to match "Orders"
                title: Text(
                  'Orders',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderListPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text(
                  'About Me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Restaurant App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOrderPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}