import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';

import 'package:open_repeater_map/repeater_list.dart';
import 'package:open_repeater_map/map_view.dart';
import 'package:open_repeater_map/types/repeater.dart';

List<Repeater> _parseRepeaters(String csvContent) {
  final rows = const CsvToListConverter().convert(csvContent, eol: '\n');
  return rows.skip(1).map((row) => Repeater.fromCsvRow(row)).toList();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Repeater> _repeaters = [];

  @override
  void initState() {
    super.initState();
    _loadRepeaters();
  }

  Future<void> _loadRepeaters() async {
    final String response = await rootBundle.loadString('data/us-repeaters.csv');
    final parsedRepeaters = await compute(_parseRepeaters, response);
    setState(() {
      _repeaters = parsedRepeaters;
    });
  }

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Repeaters';
      case 1:
        return 'Map';
      default:
        return 'Open Repeater Book';
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return RepeaterList(key: RepeaterList.globalKey, repeaters: _repeaters);
      case 1:
        return MapView(repeaters: _repeaters);
      default:
        return RepeaterList(key: RepeaterList.globalKey, repeaters: _repeaters);
    }
  }

  void _onDrawerItemTapped(BuildContext context, int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Repeater Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(_title),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text(
                    'Open Repeater Book',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Repeater List'),
                  selected: _selectedIndex == 0,
                  onTap: () => _onDrawerItemTapped(context, 0),
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Map'),
                  selected: _selectedIndex == 1,
                  onTap: () => _onDrawerItemTapped(context, 1),
                ),
              ],
            ),
          ),
          body: _buildBody(),
          floatingActionButton: _selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () => RepeaterList.globalKey.currentState?.showFilterSheet(),
                  tooltip: 'Filter',
                  child: const Icon(Icons.filter_list),
                )
              : null,
        ),
      ),
    );
  }
}
