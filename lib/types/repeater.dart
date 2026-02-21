import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Repeater {
  final int rptrId;
  final double frequency;
  final double inputFreq;
  final String? pl;
  final String? tsq;
  final String nearestCity;
  final String? landmark;
  final String county;
  final String state;
  final double lat;
  final double long;
  final bool precise;
  final String callsign;
  final String use;
  final String operationalStatus;
  final bool ares;
  final bool races;
  final bool skywarn;
  final bool canwarn;
  final String? allStarNode;
  final String? echoLinkNode;
  final String? irlpNode;
  final String? wiresNode;
  final bool fmAnalog;
  final String? fmBandwidth;
  final bool dmr;
  final String? dmrColorCode;
  final String? dmrId;
  final bool dStar;
  final bool nxdn;
  final bool apcoP25;
  final String? p25Nac;
  final bool m17;
  final String? m17Can;
  final bool tetra;
  final String? tetraMcc;
  final String? tetraMnc;
  final bool systemFusion;
  final String? notes;
  final String lastUpdate;

  Repeater({
    required this.rptrId,
    required this.frequency,
    required this.inputFreq,
    this.pl,
    this.tsq,
    required this.nearestCity,
    this.landmark,
    required this.county,
    required this.state,
    required this.lat,
    required this.long,
    required this.precise,
    required this.callsign,
    required this.use,
    required this.operationalStatus,
    required this.ares,
    required this.races,
    required this.skywarn,
    required this.canwarn,
    this.allStarNode,
    this.echoLinkNode,
    this.irlpNode,
    this.wiresNode,
    required this.fmAnalog,
    this.fmBandwidth,
    required this.dmr,
    this.dmrColorCode,
    this.dmrId,
    required this.dStar,
    required this.nxdn,
    required this.apcoP25,
    this.p25Nac,
    required this.m17,
    this.m17Can,
    required this.tetra,
    this.tetraMcc,
    this.tetraMnc,
    required this.systemFusion,
    this.notes,
    required this.lastUpdate,
  });

  /// Creates a Repeater from a CSV row.
  /// Expected column order (0-indexed):
  /// 0: index (unused), 1: State ID, 2: Rptr ID, 3: Frequency, 4: Input Freq,
  /// 5: PL, 6: TSQ, 7: Nearest City, 8: Landmark, 9: County, 10: Lat, 11: Long,
  /// 12: Precise, 13: Callsign, 14: Use, 15: Operational Status, 16: ARES,
  /// 17: RACES, 18: SKYWARN, 19: CANWARN, 20: AllStar Node, 21: EchoLink Node,
  /// 22: IRLP Node, 23: Wires Node, 24: FM Analog, 25: FM Bandwidth, 26: DMR,
  /// 27: DMR Color Code, 28: DMR ID, 29: D-Star, 30: NXDN, 31: APCO P-25,
  /// 32: P-25 NAC, 33: M17, 34: M17 CAN, 35: Tetra, 36: Tetra MCC, 37: Tetra MNC,
  /// 38: System Fusion, 39: Notes, 40: Last Update
  factory Repeater.fromCsvRow(List<dynamic> row) {
    return Repeater(
      rptrId: int.parse(row[2].toString()),
      frequency: double.parse(row[3].toString()),
      inputFreq: double.parse(row[4].toString()),
      pl: _emptyToNull(row[5]),
      tsq: _emptyToNull(row[6]),
      nearestCity: row[7].toString(),
      landmark: _emptyToNull(row[8]),
      county: row[9].toString(),
      state: _stateNameFromId(row[1].toString().padLeft(2, '0')),
      lat: double.parse(row[10].toString()),
      long: double.parse(row[11].toString()),
      precise: _stringToBool(row[12]),
      callsign: row[13].toString(),
      use: _useFromInt(int.parse(row[14].toString())),
      operationalStatus: _operationalStatusFromInt(
        int.parse(row[15].toString()),
      ),
      ares: _stringToBool(row[16]),
      races: _stringToBool(row[17]),
      skywarn: _stringToBool(row[18]),
      canwarn: _stringToBool(row[19]),
      allStarNode: _emptyOrZeroToNull(row[20]),
      echoLinkNode: _emptyOrZeroToNull(row[21]),
      irlpNode: _emptyOrZeroToNull(row[22]),
      wiresNode: _emptyToNull(row[23]),
      fmAnalog: _stringToBool(row[24]),
      fmBandwidth: _emptyToNull(row[25]),
      dmr: _stringToBool(row[26]),
      dmrColorCode: _emptyToNull(row[27]),
      dmrId: _emptyToNull(row[28]),
      dStar: _stringToBool(row[29]),
      nxdn: _stringToBool(row[30]),
      apcoP25: _stringToBool(row[31]),
      p25Nac: _emptyToNull(row[32]),
      m17: _stringToBool(row[33]),
      m17Can: _emptyToNull(row[34]),
      tetra: _stringToBool(row[35]),
      tetraMcc: _emptyToNull(row[36]),
      tetraMnc: _emptyToNull(row[37]),
      systemFusion: _stringToBool(row[38]),
      notes: _emptyToNull(row[39]),
      lastUpdate: row[40].toString(),
    );
  }

  static String? _emptyToNull(dynamic value) {
    if (value == null || value == '') return null;
    return value.toString();
  }

  static String? _emptyOrZeroToNull(dynamic value) {
    if (value == null || value == '' || value == '0' || value == 0) return null;
    return value.toString();
  }

  static bool _stringToBool(dynamic value) {
    return value.toString() == '1';
  }

  static String _useFromInt(int value) {
    const uses = ['OPEN', 'CLOSED', 'PRIVATE'];
    return uses[value];
  }

  static String _operationalStatusFromInt(int value) {
    const statuses = ['Off-air', 'On-air', 'Unknown'];
    return statuses[value];
  }

  static const _stateNames = <String, String>{
    '01': 'Alabama',
    '02': 'Alaska',
    '04': 'Arizona',
    '05': 'Arkansas',
    '06': 'California',
    '08': 'Colorado',
    '09': 'Connecticut',
    '10': 'Delaware',
    '11': 'District of Columbia',
    '12': 'Florida',
    '13': 'Georgia',
    '15': 'Hawaii',
    '16': 'Idaho',
    '17': 'Illinois',
    '18': 'Indiana',
    '19': 'Iowa',
    '20': 'Kansas',
    '21': 'Kentucky',
    '22': 'Louisiana',
    '23': 'Maine',
    '24': 'Maryland',
    '25': 'Massachusetts',
    '26': 'Michigan',
    '27': 'Minnesota',
    '28': 'Mississippi',
    '29': 'Missouri',
    '30': 'Montana',
    '31': 'Nebraska',
    '32': 'Nevada',
    '33': 'New Hampshire',
    '34': 'New Jersey',
    '35': 'New Mexico',
    '36': 'New York',
    '37': 'North Carolina',
    '38': 'North Dakota',
    '39': 'Ohio',
    '40': 'Oklahoma',
    '41': 'Oregon',
    '42': 'Pennsylvania',
    '44': 'Rhode Island',
    '45': 'South Carolina',
    '46': 'South Dakota',
    '47': 'Tennessee',
    '48': 'Texas',
    '49': 'Utah',
    '50': 'Vermont',
    '51': 'Virginia',
    '53': 'Washington',
    '54': 'West Virginia',
    '55': 'Wisconsin',
    '56': 'Wyoming',
  };

  static String _stateNameFromId(String stateId) {
    return _stateNames[stateId]!;
  }

  Marker toMarker({VoidCallback? onTap}) {
    Color color = operationalStatus == 'On-air' ? Colors.green : Colors.red;
    return Marker(
      point: LatLng(lat, long),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(Icons.cell_tower, color: Color(0xFFFFFFFF), size: 20),
        ),
      ),
    );
  }
}
