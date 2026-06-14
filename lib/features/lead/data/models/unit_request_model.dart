class UnitRequest {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerNationalId;
  final String unitCode;
  final String unitType;
  final String projectName;
  final String zone;
  final double unitPrice;
  final String paymentType;
  final DateTime requestDate;

  const UnitRequest({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerNationalId,
    required this.unitCode,
    required this.unitType,
    required this.projectName,
    required this.zone,
    required this.unitPrice,
    required this.paymentType,
    required this.requestDate,
  });
}
