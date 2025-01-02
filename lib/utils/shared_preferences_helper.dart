import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:convert';
import '../models/expense.dart';

class SharedPreferencesHelper {
  static const _emailKey = 'email';
  static const _passwordKey = 'password';
  static const String _expensesKey = 'expenses';

  // Save user data permanently (email and password)
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, user.email);
    prefs.setString(_passwordKey, user.password);
  }

  // Get user data (email and password)
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    if (email != null && password != null) {
      return User(email: email, password: password);
    }
    return null;
  }

  // Clear user data (delete user from SharedPreferences)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_emailKey);
    prefs.remove(_passwordKey);
  }


  // Save expenses to SharedPreferences
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson =
    expenses.map((expense) => json.encode(expense.toMap())).toList();
    await prefs.setStringList(_expensesKey, expensesJson);
  }

  // Retrieve expenses from SharedPreferences
  static Future<List<Expense>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? expensesJson = prefs.getStringList(_expensesKey);
    if (expensesJson == null) {
      return [];
    }
    return expensesJson
        .map((expense) => Expense.fromMap(json.decode(expense)))
        .toList();
  }

  // Method to delete a specific expense
  static Future<void> deleteExpense(String title) async {
    final List<Expense> currentExpenses = await getExpenses();
    final List<Expense> updatedExpenses = currentExpenses
        .where((expense) => expense.title != title) // Keep only expenses that don't match the title
        .toList();

    await saveExpenses(updatedExpenses);
  }
}

