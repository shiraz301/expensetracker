import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/shared_preferences_helper.dart';
import '../utils/category_service.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;
  final _amountFocusNode = FocusNode();  // Focus node for amount field

  List<String> categories = [];  // List to store categories

  @override
  void initState() {
    super.initState();
    _loadCategories();  // Fetch categories when screen is initialized
  }

  // Fetching categories from the backend
  Future<void> _loadCategories() async {
    try {
      List<String> fetchedCategories = await CategoryService.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
      print('Categories loaded: $categories'); // Debug log
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Adding Expense
  void _addExpense() async {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);
    final description = _descriptionController.text;

    if (title.isNotEmpty &&
        amount != null &&
        amount > 0 &&
        description.isNotEmpty &&
        _selectedDate != null &&
        _selectedCategory != null) {
      final newExpense = Expense(
        title: title,
        amount: amount,
        description: description,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        category: _selectedCategory!,  // Include selected category
      );

      // Save the new expense to SharedPreferences
      final expenses = await SharedPreferencesHelper.getExpenses();
      expenses.add(newExpense);
      await SharedPreferencesHelper.saveExpenses(expenses);

      Navigator.pop(context, true); // Return true to update home screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16),

            // Amount Text Field with validation for only numbers
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              focusNode: _amountFocusNode,
              onSubmitted: (_) {
                // Dismiss the keyboard when done
                _amountFocusNode.unfocus();
              },
              onChanged: (value) {
                // You can validate the input here (allow only numbers)
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter a valid number'),
                  ));
                }
              },
            ),
            SizedBox(height: 16),

            // Description Text Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16),

            // Date and Category Section (Centered)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date Section
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Category Dropdown Section
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedCategory == null ? 'No Category' : _selectedCategory!,
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          _showCategoryDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Center the Add Expense button
            Center(
              child: ElevatedButton(
                onPressed: _addExpense,
                child: Text('Add Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show category dialog
  void _showCategoryDialog() async {
    // Check if categories are loaded
    print('Categories in dialog: $categories');
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: SingleChildScrollView(
            child: Column(
              children: categories.isEmpty
                  ? [Text('No categories available')] // Handle case when no categories are available
                  : categories.map<Widget>((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

}
