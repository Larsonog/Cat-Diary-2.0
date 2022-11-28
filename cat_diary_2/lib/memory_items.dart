import 'package:flutter/material.dart';
import 'assets/icon.dart';

class Item {
  const Item({required this.name, required this.points});

  final String name;
  final String points;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef MemoriesChangedCallback = Function(Item item, bool completed);
typedef MemoriesRemovedCallback = Function(Item item);

class MemoriesItem extends StatelessWidget {
  MemoriesItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final MemoriesChangedCallback onListChanged;
  final MemoriesRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  //int points = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onListChanged(item, completed);
        },
        onLongPress: completed
            ? () {
                onDeleteItem(item);
              }
            : null,
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: const Icon(MyFlutterApp.cat),
        ),
        title: Text(
          item.name,
          style: _getTextStyle(context),
        ),
        trailing: Text(item.points)
        //trailing: Row(
        //  children: <Widget>[
        //     points!=0? new  IconButton(icon: new Icon(Icons.remove),onPressed: ()=> setState(()=> points--),):new Container(),
        //     new Text(points.toString()),
        //    new IconButton(icon: new Icon(Icons.add),onPressed: ()=>setState(()=> points++))
        // ]
        // )
        );
  }
}
