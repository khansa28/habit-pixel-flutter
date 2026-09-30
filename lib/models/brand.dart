class Brand {
  final int intSeqId;
  final int intCompanyId;
  final String varName;
  final String? varDescription;
  final DateTime? dtCreationDate;
  final int? intCreatedBy;
  final DateTime? dtUpdatedDate;
  final int? intUpdatedBy;
  final int syncStatus;

  Brand({
    required this.intSeqId,
    required this.intCompanyId,
    required this.varName,
    this.varDescription,
    this.dtCreationDate,
    this.intCreatedBy,
    this.dtUpdatedDate,
    this.intUpdatedBy,
    this.syncStatus = 0,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      intSeqId: json['intSeqId'],
      intCompanyId: json['intCompanyId'],
      varName: json['varName'] ?? '',
      varDescription: json['varDescription'],
      dtCreationDate: json['dtCreationDate'] != null
          ? DateTime.tryParse(json['dtCreationDate'])
          : null,
      intCreatedBy: json['intCreatedBy'],
      dtUpdatedDate: json['dtUpdatedDate'] != null
          ? DateTime.tryParse(json['dtUpdatedDate'])
          : null,
      intUpdatedBy: json['intUpdatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'intSeqId': intSeqId,
      'intCompanyId': intCompanyId,
      'varName': varName,
      'varDescription': varDescription,
      'dtCreationDate': dtCreationDate?.toIso8601String(),
      'intCreatedBy': intCreatedBy,
      'dtUpdatedDate': dtUpdatedDate?.toIso8601String(),
      'intUpdatedBy': intUpdatedBy,
      'syncStatus': syncStatus,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      intSeqId: map['intSeqId'],
      intCompanyId: map['intCompanyId'],
      varName: map['varName'] ?? '',
      varDescription: map['varDescription'],
      dtCreationDate: map['dtCreationDate'] != null
          ? DateTime.tryParse(map['dtCreationDate'])
          : null,
      intCreatedBy: map['intCreatedBy'],
      dtUpdatedDate: map['dtUpdatedDate'] != null
          ? DateTime.tryParse(map['dtUpdatedDate'])
          : null,
      intUpdatedBy: map['intUpdatedBy'],
      syncStatus: map['syncStatus'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'intSeqId': intSeqId,
    'intCompanyId': intCompanyId,
    'varName': varName,
    'varDescription': varDescription,
    'intCreatedBy': intCreatedBy,
  };
}
}
