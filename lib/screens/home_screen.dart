import 'package:flutter/material.dart';
import '../screens/add_expense_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/settings_screen.dart';
import '../utils/shared_preferences_helper.dart';
import '../models/expense.dart';
import 'expense_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  // Fetch expenses from SharedPreferences
  Future<void> _loadExpenses() async {
    final expenses = await SharedPreferencesHelper.getExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();  // Load expenses when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            elevation: 5,
            child: ListTile(
              title: Text(expense.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Amount: \$${expense.amount}\nDate: ${expense.date}'),
              isThreeLine: true,
              onTap: () {
                // Navigate to expense details if needed
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetailsScreen(expense: expense),
                    ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // When floating button is pressed, navigate to AddExpenseScreen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (result != null) {
            // If there's a result, load the updated expenses list
            _loadExpenses();
          }
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Adjust Drawer Header with matching design
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // Use app's primary color
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align the text to the left
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Statistics'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

