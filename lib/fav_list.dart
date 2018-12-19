import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteList extends StatefulWidget {
  final Set<String> data;
  final Function savePrefs;
  final TextStyle biggerFont;
  FavoriteList({Key key, this.data, this.savePrefs, this.biggerFont})
      : super(key: key);

  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  Set<String> _saved;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _saved = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = _saved.map(
      (String word) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                word,
                style: widget.biggerFont,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _saved.remove(word);
                    widget.savePrefs(_saved);
                  });
                },
              )
            ],
          ),
        );
      },
    );

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
