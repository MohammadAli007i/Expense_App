import 'package:flutter/material.dart';
import 'package:expenses/database/database_helper.dart';
import 'package:expenses/model/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  late Future<List<Expense>> _expenseList;
  DateTime? _startDate;
  DateTime? _endDate;
  double _totalAllowance = 0.0;

  ExpenseProvider() {
    _updateExpenseList();
  }

  Future<List<Expense>> get expenseList => _expenseList;
  double get totalAllowance => _totalAllowance;

  void _updateExpenseList() {
    _expenseList = DatabaseHelper().getExpenses().then((expenses) {
      expenses.sort((a, b) => a.date.compareTo(b.date));
      _calculateTotalAllowance(expenses);
      notifyListeners();
      return expenses;
    });
  }

  void _filterExpensesByDate() {
    _expenseList = DatabaseHelper().getExpenses().then((expenses) {
      if (_startDate != null && _endDate != null) {
        expenses = expenses.where((expense) {
          return expense.date.isAfter(_startDate!.subtract(Duration(days: 1))) &&
              expense.date.isBefore(_endDate!.add(Duration(days: 1)));
        }).toList();
      }
      expenses.sort((a, b) => a.date.compareTo(b.date));
      _calculateTotalAllowance(expenses);
      notifyListeners();
      return expenses;
    });
  }

  void _calculateTotalAllowance(List<Expense> expenses) {
    _totalAllowance = expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void setDateRange(DateTimeRange dateRange) {
    _startDate = dateRange.start;
    _endDate = dateRange.end;
    _filterExpensesByDate();
  }

  void addOrUpdateExpense(Expense expense) {
    if (expense.id == null) {
      DatabaseHelper().insertExpense(expense);
    } else {
      DatabaseHelper().updateExpense(expense);
    }
    _updateExpenseList();
  }

  void deleteExpense(int id) {
    DatabaseHelper().deleteExpense(id);
    _updateExpenseList();
  }
}
