// cool thought s you have about your pet cat that you want to record into an app
// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'assets/icon.dart';
import 'assets/thoughticon.dart';
import 'memory_items.dart';

class Memories extends StatefulWidget {
  const Memories({super.key});

  @override
  State createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  int _counter = 0;

  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _zero() {
    setState(() {
      _counter = 0;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Thought To Add'),
            content: TextField(
              key: const Key("Thought Key"),
              maxLines:
                  4, // https://www.fluttercampus.com/guide/176/how-to-make-multi-line-textfield-input-textarea-in-flutter/#:~:text=How%20to%20Make%20Multi-line%20TextField%20in%20Flutter%3A%20TextField%28keyboardType%3A,line%20that%20looks%20exactly%20like%20textarea%20in%20HTML.
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "type it out here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('Add Memory'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText, _counter);
                    Navigator.pop(context);
                    _inputController.clear();
                    _zero();
                  });
                },
              ),
              ElevatedButton(
                key: const Key("Pointsgood"),
                style: yesStyle,
                child: const Text('Good'),
                onPressed: () {
                  setState(() {
                    _incrementCounter();
                  });
                },
              ),
              ElevatedButton(
                key: const Key("Pointbad"),
                style: yesStyle,
                child: const Text('Bad'),
                onPressed: () {
                  setState(() {
                    _decrementCounter();
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              //_handleNewItem(valueText, _counter);
                              Navigator.pop(context);
                              _inputController.clear();
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [
    Item(name: "add more cool cat things", points: "0")
  ];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, int counter) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText, points: counter.toString());
      items.insert(0, item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thoughts about your pet cat'),
      ),

      //Found how to add all the buttons here: https://www.fluttercampus.com/guide/19/how-to-add-multiple-floating-action-buttons-in-one-screen-flutter-app/#:~:text=How%20to%20Add%20Multiple%20Floating%20Action%20Buttons%20in,%28%29%20widget%20to%20add%20multiple%20floating%20action%20buttons.
      floatingActionButton: Wrap(
        //will break to another line on overflow
        direction: Axis.vertical, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                key: const Key("TextInput"),
                onPressed: () {
                  _displayTextInputDialog(context);
                  //action code for button 1
                },
                child: const Icon(Icons.add),
              )), //button first

          // Add more buttons here
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: items.map((item) {
          return MemoriesItem(
            item: item,
            completed: _itemSet.contains(item),
            onListChanged: _handleListChanged,
            onDeleteItem: _handleDeleteItem,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Thoughts about Pet recorder',
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
    home: Memories(),
  ));
}
