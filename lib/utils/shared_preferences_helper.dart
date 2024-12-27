import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:convert';
import '../models/expense.dart';

class SharedPreferencesHelper {
  static const _userKey = 'user';
  static const _passwordKey = 'password';
  static const String _expensesKey = 'expenses';

  // Save user data permanently
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, user.username);
    prefs.setString(_passwordKey, user.password);
  }

  // Get user data
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_userKey);
    final password = prefs.getString(_passwordKey);
    if (username != null && password != null) {
      return User(username: username, password: password);
    }
    return null; // Return null if no user data is stored
  }

  // Clear user data (delete user from SharedPreferences)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userKey);
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

