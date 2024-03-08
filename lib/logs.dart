import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  Map<String, String> allSharedPreferencesData = {};
  List<String> filteredKeys = [];

  @override
  void initState() {
    super.initState();
    _retrieveAllSharedPreferencesData();
  }

  Future<void> _retrieveAllSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList()..sort(); // Sort keys alphabetically
    setState(() {
      allSharedPreferencesData = keys.fold<Map<String, String>>({}, (prev, key) {
        prev[key] = prefs.getString(key) ?? '';
        return prev;
      });
      // Initialize filtered keys with all keys initially
      filteredKeys = allSharedPreferencesData.keys.toList();
    });
    // Logging after retrieving data
    print('Retrieved SharedPreferences data: $allSharedPreferencesData');
  }

  Future<void> _clearAllSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all data in SharedPreferences.
    _retrieveAllSharedPreferencesData(); // Refresh the data displayed in the UI.
    // Logging after clearing data
    print('Cleared SharedPreferences data');
  }

  void _filterData(String query) {
    setState(() {
      filteredKeys = allSharedPreferencesData.keys.where((key) => key.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Logging on page build
    print('Building LogsPage');

    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate(allSharedPreferencesData));
            },
          ),
        ],
      ),

      body: 
      
      ListView.builder(
  itemCount: filteredKeys.length,
  itemBuilder: (context, index) {
    String key = filteredKeys[index];
    String value = allSharedPreferencesData[key] ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0), // Adjust the vertical spacing here
      child: ListTile(
        title: Text('$key: $value'), // Display key and value together
      ),
    );
  },
),

      
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAllSharedPreferencesData,
        child: Icon(Icons.delete),
        tooltip: 'Clear Logs',
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final Map<String, String> data;

  CustomSearchDelegate(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data.entries.toList()
        : data.entries.where((entry) => entry.key.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final entry = suggestionList[index];
        return ListTile(
          title: Text('${entry.key}: ${entry.value}'),
          onTap: () {
            close(context, entry.key);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LogsPage(),
  ));
}
