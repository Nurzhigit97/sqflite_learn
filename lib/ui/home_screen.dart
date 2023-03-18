import 'package:flutter/material.dart';
import 'package:sqflite_learn/data/services/sql_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journals = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    _refreshJournals();
    print("..............number of items ${_journals.length}");

    super.initState();
  }

  void _refreshJournals() async {
    final data = await SqlHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Padding(
          // padding: const EdgeInsets.only(
          //   top: 15,
          //   left: 15,
          //   right: 15,
          //   // bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          // ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Title...'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description...'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _addItem();
                  if (id != null) {
                    await _updateItem(id);
                  }

                  _titleController.text = '';
                  _descriptionController.text = '';
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'CreateNew' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SQL'),
      ),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.green[200],
          child: ListTile(
            title: Text(
              _journals[index]['title'],
            ),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _showForm(_journals[index]['id']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(_journals[index]['id']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  _addItem() async {
    await SqlHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
    print("..............number of items ${_journals.length}");
  }

  _updateItem(int id) async {
    await SqlHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  _deleteItem(int id) async {
    await SqlHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted a journal'),
      ),
    );
    _refreshJournals();
  }
}
