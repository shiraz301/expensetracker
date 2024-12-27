import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/shared_preferences_helper.dart'; // Import SharedPreferences helper

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense; // Declare the 'expense' parameter

  // Constructor to receive the 'expense' data
  ExpenseDetailsScreen({required this.expense}); // Correctly define the constructor

  Future<void> _deleteExpense(BuildContext context) async {
    // Call the delete method from SharedPreferencesHelper
    await SharedPreferencesHelper.deleteExpense(expense.title);
    Navigator.pop(context); // Return to the previous screen after deletion
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
                    SizedBox(height: 16),
                    // Action buttons for editing and deleting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
