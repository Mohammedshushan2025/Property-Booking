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
  final String? assignedSalesPersonId;

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
    this.assignedSalesPersonId,
  });

  UnitRequest copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerNationalId,
    String? unitCode,
    String? unitType,
    String? projectName,
    String? zone,
    double? unitPrice,
    String? paymentType,
    DateTime? requestDate,
    String? assignedSalesPersonId,
  }) {
    return UnitRequest(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerNationalId: customerNationalId ?? this.customerNationalId,
      unitCode: unitCode ?? this.unitCode,
      unitType: unitType ?? this.unitType,
      projectName: projectName ?? this.projectName,
      zone: zone ?? this.zone,
      unitPrice: unitPrice ?? this.unitPrice,
      paymentType: paymentType ?? this.paymentType,
      requestDate: requestDate ?? this.requestDate,
      assignedSalesPersonId: assignedSalesPersonId ?? this.assignedSalesPersonId,
    );
  }
}
