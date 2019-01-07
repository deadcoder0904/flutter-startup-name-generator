import 'dart:async';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fav_list.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _suggestions = <String>[];
  Set<String> _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  void loadPrefs() async {
    final SharedPreferences prefs = await _prefs;
    List<String> saved = prefs.getStringList("saved") ?? List<String>();
    _saved = saved.map((String str) {
      final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");
      List<String> splitPascalCase(String input) =>
          input.split(beforeNonLeadingCapitalLetter);
      List<String> words = splitPascalCase(str);
      return WordPair(words[0], words[1]).toString();
    }).toSet();
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions
              .addAll(generateWordPairs().take(10).map((f) => f.asPascalCase));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  void savePrefs(Set<String> _saved) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList('saved', _saved.toList());
  }

  Widget _buildRow(String pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.pink[300] : null,
      ),
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              _saved.remove(pair);
              savePrefs(_saved);
            } else {
              _saved.add(pair);
              savePrefs(_saved);
            }
          },
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => FavoriteList(
            data: _saved, savePrefs: savePrefs, biggerFont: _biggerFont),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
