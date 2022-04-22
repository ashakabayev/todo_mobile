import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_mobile_masters/about.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class Item {
  String title;
  DateTime dateTime;
  TimeOfDay timeOfDay;
  bool isReminder;
  Item({required this.title, required this.dateTime, required this.timeOfDay, required this.isReminder});
}

class _HomePageState extends State<HomePage> {
  List<Item> todos = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _controller = TextEditingController();

  _addTask() {
    bool isReminderOn = false;
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 3.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), // set rounded corner radius
                      ),
                      child: TextFormField(
                        controller: _controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Add Task',
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 3.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: ListTile(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (timeOfDay != null && timeOfDay != selectedTime) {
                            setState(() {
                              selectedTime = timeOfDay;
                            });
                          }
                        },
                        title: Text(
                          '${DateFormat("MMMM").format(selectedDate)} ${selectedDate.day} at ${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.toString().split('.')[1]}', //${DateFormat('hh:mm a').format(selectedDate)}
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text('Reminder:'),
                          Checkbox(
                              value: isReminderOn,
                              onChanged: (e) {
                                setState(() {
                                  isReminderOn = !isReminderOn;
                                });
                              }),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          todos.add(
                            Item(
                              title: _controller.text,
                              isReminder: isReminderOn,
                              dateTime: selectedDate,
                              timeOfDay: selectedTime,
                            ),
                          );
                          _controller.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              _addTask();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    todos[index].isReminder = !todos[index].isReminder;
                    setState(() {});
                  },
                  leading: todos[index].isReminder ? Container(color: Colors.green, width: 20, height: double.maxFinite) : null,
                  title: Text(todos[index].title),
                  subtitle: Text(
                      '${DateFormat("MMMM").format(todos[index].dateTime)} ${todos[index].dateTime.day} at ${todos[index].timeOfDay.hour}:${todos[index].timeOfDay.minute} ${todos[index].timeOfDay.period.toString().split('.')[1]} '),
                  trailing: IconButton(
                    onPressed: () {
                      todos.removeAt(index);
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel),
                  ),
                );
              },
            ),
          ),
          Text('CopyRight © 2022'),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            },
            child: Text('About'),
          ),
          SizedBox(height: 100)
        ],
      ),
    );
  }
}
