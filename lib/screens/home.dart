import 'package:expenses/screens/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses/model/expense_model.dart';

class ExpenseListScreen extends StatelessWidget {
  void _showNotificationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addOrUpdateExpense(BuildContext context, {Expense? expense}) async {
    final _formKey = GlobalKey<FormState>();
    String? amount = expense?.amount.toString();
    String? title = expense?.title;
    String? description = expense?.description;
    DateTime? date = expense?.date;
    TextEditingController dateController = TextEditingController(
      text: expense != null ? DateFormat('yyyy-MM-dd').format(expense.date) : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        expense == null ? 'Add Expense' : 'Update Expense',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: amount,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) => amount = value,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onChanged: (value) => title = value,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onChanged: (value) => description = value,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setModalState(() {
                              date = pickedDate;
                              dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick a date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final newExpense = Expense(
                                  id: expense?.id,
                                  title: title!,
                                  amount: double.parse(amount!),
                                  description: description!,
                                  date: date!,
                                );
                                Provider.of<ExpenseProvider>(context, listen: false).addOrUpdateExpense(newExpense);
                                Navigator.pop(context);
                                _showNotificationDialog(
                                  context,
                                  expense == null ? 'Expense added successfully' : 'Expense updated successfully',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              expense == null ? 'Add' : 'Update',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (expense != null)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                                expenseProvider.deleteExpense(expense.id!);
                                _showNotificationDialog(context, 'Expense deleted successfully');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              DateTimeRange? pickedDateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                initialDateRange: DateTimeRange(
                  start: DateTime.now().subtract(Duration(days: 7)),
                  end: DateTime.now(),
                ),
              );
              if (pickedDateRange != null) {
                Provider.of<ExpenseProvider>(context, listen: false).setDateRange(pickedDateRange);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              final totalAllowance = Provider.of<ExpenseProvider>(context, listen: false).totalAllowance;
              _showNotificationDialog(context, 'Total Allowance: \$${totalAllowance.toStringAsFixed(2)}');
            },
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          return FutureBuilder(
            future: expenseProvider.expenseList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final expenses = snapshot.data as List<Expense>;
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          _addOrUpdateExpense(context, expense: expense);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  expense.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd').format(expense.date),
                                ),
                                trailing: Text(
                                  '\$${expense.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _addOrUpdateExpense(context, expense: expense);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No expenses found'));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrUpdateExpense(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
