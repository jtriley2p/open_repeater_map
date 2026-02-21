import 'package:flutter/material.dart';
import 'package:open_repeater_map/repeater_details/repeater_details.dart';
import 'package:open_repeater_map/types/repeater.dart';

class RepeaterList extends StatefulWidget {
  const RepeaterList({super.key, required this.repeaters});

  final List<Repeater> repeaters;

  static final GlobalKey<RepeaterListState> globalKey =
      GlobalKey<RepeaterListState>();

  @override
  State<RepeaterList> createState() => RepeaterListState();
}

class RepeaterListState extends State<RepeaterList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter state
  final Set<String> _selectedStatuses = {'On-air'};
  final Set<String> _selectedUses = {'OPEN'};
  final Set<String> _selectedBands = {'2m', '70cm'};

  static const List<String> allStatuses = ['On-air', 'Off-air', 'Unknown'];
  static const List<String> allUses = ['OPEN', 'CLOSED', 'PRIVATE'];
  static const List<String> allBands = [
    '10m',
    '6m',
    '2m',
    '1.25m',
    '70cm',
    '33cm',
    '23cm',
  ];

  static String? bandFromFrequency(double freq) {
    if (freq >= 28.0 && freq <= 29.7) return '10m';
    if (freq >= 50.0 && freq <= 54.0) return '6m';
    if (freq >= 144.0 && freq <= 148.0) return '2m';
    if (freq >= 222.0 && freq <= 225.0) return '1.25m';
    if (freq >= 420.0 && freq <= 450.0) return '70cm';
    if (freq >= 902.0 && freq <= 928.0) return '33cm';
    if (freq >= 1240.0 && freq <= 1300.0) return '23cm';
    return null;
  }

  List<Repeater> get filteredRepeaters {
    var results = widget.repeaters.where((r) {
      final band = bandFromFrequency(r.frequency);
      return _selectedStatuses.contains(r.operationalStatus) &&
          _selectedUses.contains(r.use) &&
          (band != null && _selectedBands.contains(band));
    });

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where(
        (r) =>
            r.callsign.toLowerCase().contains(query) ||
            r.nearestCity.toLowerCase().contains(query) ||
            r.county.toLowerCase().contains(query) ||
            r.state.toLowerCase().contains(query),
      );
    }

    return results.toList();
  }

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setSheetState) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Operational Status',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            allStatuses.map((status) {
                              final selected = _selectedStatuses.contains(
                                status,
                              );
                              return FilterChip(
                                label: Text(status),
                                selected: selected,
                                onSelected: (value) {
                                  setSheetState(() {
                                    if (value) {
                                      _selectedStatuses.add(status);
                                    } else if (_selectedStatuses.length > 1) {
                                      _selectedStatuses.remove(status);
                                    }
                                  });
                                  setState(() {});
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Use',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            allUses.map((use) {
                              final selected = _selectedUses.contains(use);
                              return FilterChip(
                                label: Text(use),
                                selected: selected,
                                onSelected: (value) {
                                  setSheetState(() {
                                    if (value) {
                                      _selectedUses.add(use);
                                    } else if (_selectedUses.length > 1) {
                                      _selectedUses.remove(use);
                                    }
                                  });
                                  setState(() {});
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Band',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            allBands.map((band) {
                              final selected = _selectedBands.contains(band);
                              return FilterChip(
                                label: Text(band),
                                selected: selected,
                                onSelected: (value) {
                                  setSheetState(() {
                                    if (value) {
                                      _selectedBands.add(band);
                                    } else if (_selectedBands.length > 1) {
                                      _selectedBands.remove(band);
                                    }
                                  });
                                  setState(() {});
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
          ),
    );
  }

  String subtitle(Repeater repeater) {
    final offset = (repeater.inputFreq - repeater.frequency).toStringAsFixed(3);
    return "${repeater.frequency.toStringAsFixed(3)} MHz ($offset)";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by callsign, city, or state.',
              prefixIcon: const Icon(Icons.search),
              border: UnderlineInputBorder(),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                      : null,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredRepeaters.length,
            prototypeItem: const ListTile(title: Text("RepeaterList")),
            itemBuilder: (context, index) {
              final repeater = filteredRepeaters[index];

              return ListTile(
                title: Text("${repeater.callsign}: "),
                subtitle: Text(subtitle(repeater)),
                trailing: Text('${repeater.county}, ${repeater.state}'),
                onTap:
                    () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepeaterDetails(repeater),
                        ),
                      ),
                    },
              );
            },
          ),
        ),
      ],
    );
  }
}
