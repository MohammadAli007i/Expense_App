import 'package:expenses/database/database_helper.dart';
import 'package:expenses/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExpenseListScreen(),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<List<Expense>> _expenseList;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _updateExpenseList();
  }

  void _updateExpenseList() {
    setState(() {
      _expenseList = DatabaseHelper().getExpenses().then((expenses) {
        expenses.sort((a, b) => a.date.compareTo(b.date));
        return expenses;
      });
    });
  }

  void _filterExpensesByDate() {
    setState(() {
      _expenseList = DatabaseHelper().getExpenses().then((expenses) {
        if (_startDate != null && _endDate != null) {
          expenses = expenses.where((expense) {
            return expense.date.isAfter(_startDate!.subtract(Duration(days: 1))) &&
                expense.date.isBefore(_endDate!.add(Duration(days: 1)));
          }).toList();
        }
        expenses.sort((a, b) => a.date.compareTo(b.date));
        return expenses;
      });
    });
  }

  void _addOrUpdateExpense({Expense? expense}) async {
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
                          DateTime initialDate = date ?? DateTime.now();
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setModalState(() {
                              date = pickedDate;
                              dateController.text = DateFormat('yyyy-MM-dd').format(date!);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
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
                                Navigator.pop(context);
                                if (amount != null && title != null && description != null && date != null) {
                                  final newExpense = Expense(
                                    id: expense?.id,
                                    title: title!,
                                    amount: double.parse(amount!),
                                    description: description!,
                                    date: date!,
                                  );

                                  if (expense == null) {
                                    DatabaseHelper().insertExpense(newExpense);
                                  } else {
                                    DatabaseHelper().updateExpense(newExpense);
                                  }

                                  _updateExpenseList();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
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
                                _deleteExpense(expense.id!);
                                _updateExpenseList();
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

  void _deleteExpense(int id) async {
    await DatabaseHelper().deleteExpense(id);
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
                  start: _startDate ?? DateTime.now().subtract(Duration(days: 7)),
                  end: _endDate ?? DateTime.now(),
                ),
              );
              if (pickedDateRange != null) {
                setState(() {
                  _startDate = pickedDateRange.start;
                  _endDate = pickedDateRange.end;
                  _filterExpensesByDate();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _expenseList,
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
                      _addOrUpdateExpense(expense: expense);
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
                              '\r${expense.amount.toStringAsFixed(2)}',
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
                            _addOrUpdateExpense(expense: expense);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (expense.id != null) {
                              _deleteExpense(expense.id!);
                              _updateExpenseList();
                            }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrUpdateExpense();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
