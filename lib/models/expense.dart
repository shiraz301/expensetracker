class Expense {
  final String title;
  final double amount;
  final String description;
  final String date;
  final String category; // New field added

  Expense({
    required this.title,
    required this.amount,
    required this.description,
    required this.date,
    required this.category, // Include in the constructor
  });

  // Convert Expense to a Map to store in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'description': description,
      'date': date,
      'category': category, // Add category to Map
    };
  }

  // Convert Map to Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      title: map['title'],
      amount: map['amount'],
      description: map['description'],
      date: map['date'],
      category: map['category'], // Add category from Map
    );
  }
}
