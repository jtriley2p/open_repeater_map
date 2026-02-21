import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:open_repeater_map/types/repeater.dart';
import 'package:open_repeater_map/repeater_details/repeater_details.dart';

class MapView extends StatelessWidget {
  const MapView({super.key, required this.repeaters});

  final List<Repeater> repeaters;

  void _showRepeaterInfo(BuildContext context, Repeater repeater) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repeater.callsign,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Downlink: ${repeater.frequency.toStringAsFixed(4)} MHz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Uplink: ${repeater.inputFreq.toStringAsFixed(4)} MHz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'PL: ${repeater.pl ?? "None"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${repeater.nearestCity}, ${repeater.state}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepeaterDetails(repeater),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('View Details'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      ),
    );
  }

  List<Marker> _buildMarkers(BuildContext context) {
    final seen = <String>{};
    return repeaters
        .where((repeater) => seen.add(repeater.callsign))
        .map((repeater) => repeater.toMarker(
              onTap: () => _showRepeaterInfo(context, repeater),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(39.833333, -98.583333),
        initialZoom: 4,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.repeatermap.dev',
          tileProvider: NetworkTileProvider(
            cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
              maxCacheSize: 1_000_000_000,
            ),
          ),
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 60,
            markers: _buildMarkers(context),
            builder: (context, markers) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${markers.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap:
                  () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
