import 'package:flutter/material.dart';
import '../../data/models/unit_model.dart';
import 'package:intl/intl.dart';

class ReservationFormProvider with ChangeNotifier {
  // Controllers (we'll keep them here to persist state)
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController meterPriceController = TextEditingController();
  final TextEditingController unitAreaController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController paymentValueController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();

  // Error states
  String? descriptionError;
  String? meterPriceError;
  String? unitAreaError;
  String? paymentValueError;
  String? mobileNumberError;
  String? nationalIdError;

  // Selected values
  String? selectedUser;
  String? selectedPaymentType;
  DateTime reservationDate = DateTime.now();
  DateTime contractDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  bool isReserving = false;

  final NumberFormat _numberFormatter = NumberFormat('#,##0.00', 'en_US');

  ReservationFormProvider() {
    customerNameController.addListener(notifyListeners);
    descriptionController.addListener(notifyListeners);
    meterPriceController.addListener(calculateTotal);
    unitAreaController.addListener(calculateTotal);
    paymentValueController.addListener(notifyListeners);
    mobileNumberController.addListener(notifyListeners);
    nationalIdController.addListener(notifyListeners);
  }

  void init(UnitModel unit) {
    // Temporarily remove listeners to avoid multiple calculateTotal and notifyListeners calls
    meterPriceController.removeListener(calculateTotal);
    unitAreaController.removeListener(calculateTotal);

    meterPriceController.text = _numberFormatter.format(
      unit.meterPriceInst ?? 0,
    );
    unitAreaController.text = unit.unitArea?.toString() ?? "0";

    // Re-add listeners
    meterPriceController.addListener(calculateTotal);
    unitAreaController.addListener(calculateTotal);

    // Initial calculation without extra notification
    _calculateTotalInternal();

    // Reset other fields for a NEW unit
    customerNameController.clear();
    descriptionController.clear();
    paymentValueController.clear();
    mobileNumberController.clear();
    nationalIdController.clear();
    selectedUser = null;
    selectedPaymentType = null;
    reservationDate = DateTime.now();
    contractDate = DateTime.now();
    dueDate = DateTime.now();

    // Reset errors
    descriptionError = null;
    meterPriceError = null;
    unitAreaError = null;
    paymentValueError = null;
    mobileNumberError = null;
    nationalIdError = null;

    notifyListeners();
  }

  void reset() {
    customerNameController.clear();
    descriptionController.clear();
    paymentValueController.clear();
    mobileNumberController.clear();
    nationalIdController.clear();
    selectedUser = null;
    selectedPaymentType = null;
    reservationDate = DateTime.now();
    contractDate = DateTime.now();
    dueDate = DateTime.now();
    descriptionError = null;
    meterPriceError = null;
    unitAreaError = null;
    paymentValueError = null;
    mobileNumberError = null;
    nationalIdError = null;
    notifyListeners();
  }

  void calculateTotal() {
    _calculateTotalInternal();
    notifyListeners();
  }

  void _calculateTotalInternal() {
    final price = _parseFormatted(meterPriceController.text);
    final area = _parseFormatted(unitAreaController.text);
    final result = _numberFormatter.format(price * area);
    if (totalPriceController.text != result) {
      totalPriceController.text = result;
    }
  }

  double _parseFormatted(String text) {
    return double.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  void setSelectedUser(String? user) {
    selectedUser = user;
    notifyListeners();
  }

  void setSelectedPaymentType(String? type) {
    selectedPaymentType = type;
    notifyListeners();
  }

  void setReservationDate(DateTime date) {
    reservationDate = date;
    notifyListeners();
  }

  void setContractDate(DateTime date) {
    contractDate = date;
    notifyListeners();
  }

  void setDueDate(DateTime date) {
    dueDate = date;
    notifyListeners();
  }

  void setError(String field, String? error) {
    switch (field) {
      case 'description':
        descriptionError = error;
        break;
      case 'meterPrice':
        meterPriceError = error;
        break;
      case 'unitArea':
        unitAreaError = error;
        break;
      case 'paymentValue':
        paymentValueError = error;
        break;
      case 'mobileNumber':
        mobileNumberError = error;
        break;
      case 'nationalId':
        nationalIdError = error;
        break;
    }
    notifyListeners();
  }

  void setReserving(bool value) {
    isReserving = value;
    notifyListeners();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    descriptionController.dispose();
    meterPriceController.dispose();
    unitAreaController.dispose();
    totalPriceController.dispose();
    paymentValueController.dispose();
    mobileNumberController.dispose();
    nationalIdController.dispose();
    super.dispose();
  }
}
