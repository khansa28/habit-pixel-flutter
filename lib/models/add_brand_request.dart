class AddBrandRequest {
  final int intSeqId;
  final int intCompanyId;
  final String varName;
  final String varDescription;
  final int? intCreatedBy;

  AddBrandRequest({
    required this.intSeqId,
    required this.intCompanyId,
    required this.varName,
    required this.varDescription,
    this.intCreatedBy,
  });

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