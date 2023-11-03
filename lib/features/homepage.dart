import 'package:flutter/material.dart';
import 'package:sqflite_tut/class/sqflite_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<dynamic, dynamic>> _animals;
  late TextEditingController _textField;
  late AnimalDatabaseHandler _db;

  @override
  void initState() {
    super.initState();

    _textField = TextEditingController();
    _db = AnimalDatabaseHandler();
    _animals = List.empty(growable: true);

    getAnimals();
  }

  @override
  void dispose() {
    _textField.dispose();
    _db.close();

    super.dispose();
  }

  Future<void> getAnimals() async {
    await _db.open();

    final animals = await _db.getAnimals(null);

    setState(() {
      _animals.clear();
      _animals.addAll(animals);
    });
  }

  Future<void> addAnimals(String animalName) async {
    await _db.open();
    await _db.insert(animalName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SQFLITE'),
      ),
      body: Column(
        children: [
          TextField(controller: _textField),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final animal = _animals[index];

                return ListTile(title: Text(animal['name']));
              },
              itemCount: _animals.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_textField.text.isEmpty) return;

          await addAnimals(_textField.text);
          _textField.clear();

          setState(() {
            getAnimals();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
