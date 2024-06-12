// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo List',
       theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, surface: Colors.blue),
        useMaterial3: true,
      ),
        home: const TodoList(),
        debugShowCheckedModeBanner: false,


    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  createState() => TodoListState();
}
class TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];

  // Much like _addTodoItem, this modifies the array of todo strings and
// notifies the app that the state has changed by using setState
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

// Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                 TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                 TextButton(
                    child: const Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index],index);
        }
        return null;
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
        title: Text(todoText),
        onTap: () => _promptRemoveTodoItem(index)
    );
  }

  // This will be called each time the + button is pressed
  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.isNotEmpty) {
      setState(() => _todoItems.add(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Todo List')
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: const Icon(Icons.add)
      ),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
         MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                  appBar: AppBar(
                      title: const Text('Add a new task')
                  ),
                  body: TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodoItem(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: EdgeInsets.all(16.0)
                    ),
                  )
              );
            }
        )
    );
  }
}