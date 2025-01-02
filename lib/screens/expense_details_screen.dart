import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/shared_preferences_helper.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final Expense expense;

  // Constructor to receive the 'expense' data
  ExpenseDetailsScreen({required this.expense});

  @override
  _ExpenseDetailsScreenState createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  late Expense expense; // Declare a local variable to hold the current expense

  @override
  void initState() {
    super.initState();
    expense = widget.expense; // Initialize with the passed expense data
  }

  Future<void> _deleteExpense(BuildContext context) async {
    await SharedPreferencesHelper.deleteExpense(expense.title);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense deleted successfully!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 300, // Limit the height of the card
            ),
            child: Card(
              elevation: 5, // Adds shadow to the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Round corners
              ),
              child: Padding(
                padding: EdgeInsets.all(12), // Reduced padding for compactness
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${expense.title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Amount: \$${expense.amount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${expense.date}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${expense.description}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Category: ${expense.category}', // Added category
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    // Action buttons for editing and deleting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Delete Button
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Confirm deletion with a dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Expense'),
                                content: Text('Are you sure you want to delete this expense?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      _deleteExpense(context); // Perform the delete operation
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
