import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pomodoro_clock/views/to_do_list.dart';

import '../controllers/circular_timer.dart';
import '../controllers/clock_controller.dart';
import '../models/count_down_timer.dart';
import '../models/todo_model.dart';
import '../utils/constants.dart';
import '../widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  final List<Icon> timesCompleted = [];

  HomePage({super.key}) {
    // Initialize times completed dot icons
    for (var i = 0; i < 3; i++) {
      timesCompleted.add(
        const Icon(
          Icons.brightness_1_rounded,
          color: Colors.blueGrey,
          size: 5.0,
        ),
      );
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Tab> myTabs = const [
    Tab(
      icon: Icon(Icons.favorite_outline_sharp),
      text: "Pomodoro",
    ),
    Tab(
      icon: Icon(Icons.free_breakfast_outlined),
      text: "Short Break",
    ),
    Tab(
      icon: Icon(Icons.free_breakfast_sharp),
      text: "Long Break",
    ),
  ];

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      print("Selected Index: " + _tabController.index.toString());
    });
  }

  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  // Change Clock button icon and controller

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    int indexTimesCompleted = 0;
    // Half Screen Dimensions
    final double height = MediaQuery.of(context).size.height / 3;
    final double width = MediaQuery.of(context).size.width / 2;
    CountDownTimer countDownShortBreak = CountDownTimer(
      duration: kShortBreakDuration,
      fillColor: Colors.pink,
      onComplete: () {
        setState(() {
          widget.timesCompleted[indexTimesCompleted] = const Icon(
            Icons.brightness_1_rounded,
            color: Colors.pink,
            size: 5.0,
          );
          indexTimesCompleted++;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Timer completed"),
              content: const Text("Start next one?"),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        });
      },
    );
    CountDownTimer countDownLongBreak = CountDownTimer(
      duration: kLongBreakDuration,
      fillColor: Colors.pink,
      onComplete: () {
        setState(() {
          widget.timesCompleted[indexTimesCompleted] = const Icon(
            Icons.brightness_1_rounded,
            color: Colors.pink,
            size: 5.0,
          );
          indexTimesCompleted++;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Timer completed"),
              content: const Text("Start next one?"),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        });
      },
    );
    CountDownTimer countDownPomodoroTimer = CountDownTimer(
      duration: kWorkDuration,
      fillColor: Colors.pink,
      onComplete: () {
        setState(() {
          widget.timesCompleted[indexTimesCompleted] = const Icon(
            Icons.brightness_1_rounded,
            color: Colors.pink,
            size: 5.0,
          );
          indexTimesCompleted++;

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Timer completed"),
              content: const Text("Start next one?"),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    // _countDownShortBreak.onComplete;
                    _tabController.animateTo(_selectedIndex += 1);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        });
      },
    );

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1d0736),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
          title: const Text('Pomodoro Clock'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(),
            tooltip: 'Add Item',
            child: const Icon(Icons.add)),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: CircularTimer.workClock(
                          height, width, countDownPomodoroTimer),
                    ),
                    const Text(
                      kWorkLabel,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.timesCompleted,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            ClockController.switchClockActionButton();
                          });
                        },
                        child: Container(
                          width: width / 2.5,
                          height: height / 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClockController.clockButton,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "#Checklist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        InkWell(
                          child: const Text(
                            "Clear All",
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            _todos.clear();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    _todos.isEmpty
                        ? const Center(
                            child: Text(
                              "No Checklist Available",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            children: _todos.map((Todo todo) {
                              return TodoItem(
                                todo: todo,
                                onTodoChanged: _handleTodoChange,
                              );
                            }).toList(),
                          )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: CircularTimer.shortBreakClock(
                          height, width, countDownShortBreak),
                    ),
                    const Text(
                      kWorkLabel,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.timesCompleted,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            ClockController.switchShortBreakClockActionButton();
                          });
                        },
                        child: Container(
                          width: width / 2.5,
                          height: height / 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClockController.clockButton,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "#Checklist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        InkWell(
                          child: const Text(
                            "Clear All",
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            _todos.clear();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    _todos.isEmpty
                        ? const Center(
                            child: Text(
                              "No Checklist Available",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            children: _todos.map((Todo todo) {
                              return TodoItem(
                                todo: todo,
                                onTodoChanged: _handleTodoChange,
                              );
                            }).toList(),
                          )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: CircularTimer.longBreakClock(
                          height, width, countDownLongBreak),
                    ),
                    const Text(
                      kWorkLabel,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.timesCompleted,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            ClockController.switchLongBreakClockActionButton();
                          });
                        },
                        child: Container(
                          width: width / 2.5,
                          height: height / 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClockController.clockButton,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "#Checklist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        InkWell(
                          child: const Text(
                            "Clear All",
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            _todos.clear();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    _todos.isEmpty
                        ? const Center(
                            child: Text(
                              "No Checklist Available",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            children: _todos.map((Todo todo) {
                              return TodoItem(
                                todo: todo,
                                onTodoChanged: _handleTodoChange,
                              );
                            }).toList(),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
