import 'package:flutter/material.dart';
import 'package:open_repeater_map/types/repeater.dart';
import 'package:open_repeater_map/repeater_details/detail_row.dart';
import 'package:open_repeater_map/repeater_details/detail_section.dart';

class RepeaterDetails extends StatelessWidget {
  final Repeater repeater;

  const RepeaterDetails(this.repeater, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text(repeater.callsign),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DetailSection(
              title: 'Frequency',
              children: [
                DetailRow(
                  label: 'Downlink',
                  value: '${repeater.frequency.toStringAsFixed(4)} MHz',
                  tooltip: 'The frequency your radio RECEIVES on.',
                ),
                DetailRow(
                  label: 'Uplink',
                  value: '${repeater.inputFreq.toStringAsFixed(4)} MHz',
                  tooltip: 'The frequency your radio TRANSMITS on.',
                ),
                DetailRow(
                  label: 'Offset',
                  value:
                      '${(repeater.inputFreq - repeater.frequency).toStringAsFixed(3)} MHz',
                ),
                if (repeater.pl != null)
                  DetailRow(label: 'PL Tone', value: '${repeater.pl} Hz'),
                if (repeater.tsq != null)
                  DetailRow(label: 'TSQ', value: '${repeater.tsq} Hz'),
                if (repeater.fmBandwidth != null)
                  DetailRow(label: 'Bandwidth', value: repeater.fmBandwidth!),
              ],
            ),
            DetailSection(
              title: 'Location',
              children: [
                DetailRow(label: 'City', value: repeater.nearestCity),
                if (repeater.landmark != null)
                  DetailRow(label: 'Landmark', value: repeater.landmark!),
                DetailRow(label: 'County', value: repeater.county),
                DetailRow(label: 'State', value: repeater.state),
                DetailRow(label: 'Country', value: "US"),
                DetailRow(
                  label: 'Coordinates',
                  value: '${repeater.lat}, ${repeater.long}',
                ),
                DetailRow(
                  label: 'Precise Location',
                  value: repeater.precise ? 'Yes' : 'No',
                ),
              ],
            ),
            DetailSection(
              title: 'Status',
              children: [
                DetailRow(label: 'Use', value: repeater.use),
                DetailRow(
                  label: 'Operational Status',
                  value: repeater.operationalStatus,
                ),
                DetailRow(label: 'Last Update', value: repeater.lastUpdate),
              ],
            ),
            DetailSection(
              title: 'Modes',
              children: [
                DetailRow(
                  label: 'FM Analog',
                  value: repeater.fmAnalog ? 'Yes' : 'No',
                ),
                DetailRow(label: 'DMR', value: repeater.dmr ? 'Yes' : 'No'),
                if (repeater.dmr && repeater.dmrColorCode != null)
                  DetailRow(
                    label: 'DMR Color Code',
                    value: repeater.dmrColorCode!,
                  ),
                if (repeater.dmr && repeater.dmrId != null)
                  DetailRow(label: 'DMR ID', value: repeater.dmrId!),
                DetailRow(
                  label: 'D-Star',
                  value: repeater.dStar ? 'Yes' : 'No',
                ),
                DetailRow(
                  label: 'System Fusion',
                  value: repeater.systemFusion ? 'Yes' : 'No',
                ),
                DetailRow(label: 'NXDN', value: repeater.nxdn ? 'Yes' : 'No'),
                DetailRow(
                  label: 'APCO P-25',
                  value: repeater.apcoP25 ? 'Yes' : 'No',
                ),
                if (repeater.apcoP25 && repeater.p25Nac != null)
                  DetailRow(label: 'P-25 NAC', value: repeater.p25Nac!),
                DetailRow(label: 'M17', value: repeater.m17 ? 'Yes' : 'No'),
                if (repeater.m17 && repeater.m17Can != null)
                  DetailRow(label: 'M17 CAN', value: repeater.m17Can!),
                DetailRow(label: 'Tetra', value: repeater.tetra ? 'Yes' : 'No'),
                if (repeater.tetra && repeater.tetraMcc != null)
                  DetailRow(label: 'Tetra MCC', value: repeater.tetraMcc!),
                if (repeater.tetra && repeater.tetraMnc != null)
                  DetailRow(label: 'Tetra MNC', value: repeater.tetraMnc!),
              ],
            ),
            DetailSection(
              title: 'Linked Systems',
              children: [
                if (repeater.allStarNode != null)
                  DetailRow(
                    label: 'AllStar Node',
                    value: repeater.allStarNode!,
                  ),
                if (repeater.echoLinkNode != null)
                  DetailRow(
                    label: 'EchoLink Node',
                    value: repeater.echoLinkNode!,
                  ),
                if (repeater.irlpNode != null)
                  DetailRow(label: 'IRLP Node', value: repeater.irlpNode!),
                if (repeater.wiresNode != null)
                  DetailRow(label: 'Wires Node', value: repeater.wiresNode!),
                if (repeater.allStarNode == null &&
                    repeater.echoLinkNode == null &&
                    repeater.irlpNode == null &&
                    repeater.wiresNode == null)
                  DetailRow(label: '', value: 'No linked systems'),
              ],
            ),
            DetailSection(
              title: 'Emergency Services',
              children: [
                DetailRow(label: 'ARES', value: repeater.ares ? 'Yes' : 'No'),
                DetailRow(label: 'RACES', value: repeater.races ? 'Yes' : 'No'),
                DetailRow(
                  label: 'SKYWARN',
                  value: repeater.skywarn ? 'Yes' : 'No',
                ),
                DetailRow(
                  label: 'CANWARN',
                  value: repeater.canwarn ? 'Yes' : 'No',
                ),
              ],
            ),
            if (repeater.notes != null)
              DetailSection(title: 'Notes', children: [Text(repeater.notes!)]),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
