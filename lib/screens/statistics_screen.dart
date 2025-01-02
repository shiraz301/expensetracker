import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/expense.dart';
import '../utils/shared_preferences_helper.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> expenses = [];
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // Load expenses from SharedPreferences
  Future<void> _loadExpenses() async {
    final List<Expense> loadedExpenses = await SharedPreferencesHelper.getExpenses();
    double total = 0;

    for (var expense in loadedExpenses) {
      total += expense.amount;
    }

    setState(() {
      expenses = loadedExpenses;
      totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the total sum of all expenses
            Text(
              'Total Expenses: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display Pie Chart if there are expenses
            if (expenses.isNotEmpty)
              Container(
                height: 300,  // Set the height of the chart
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<Expense, String>(
                      dataSource: expenses,
                      xValueMapper: (Expense expense, _) => expense.title,
                      yValueMapper: (Expense expense, _) => expense.amount,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            if (expenses.isEmpty)
              Text(
                'No expenses added yet.',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
