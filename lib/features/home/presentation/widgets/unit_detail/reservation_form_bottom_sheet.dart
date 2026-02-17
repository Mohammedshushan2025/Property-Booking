import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/reservation_form_provider.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import '../../../data/datasource/home_datasource.dart';
import '../../../data/models/unit_model.dart';
import 'unit_detail_date_picker.dart';
import 'unit_detail_dropdown.dart';
import 'unit_detail_label.dart';
import 'unit_detail_text_field.dart';

class ReservationFormBottomSheet extends StatefulWidget {
  final UnitModel unit;
  final VoidCallback? onRefresh;
  final HomeDatasource homeDatasource;

  const ReservationFormBottomSheet({
    super.key,
    required this.unit,
    this.onRefresh,
    required this.homeDatasource,
  });

  @override
  State<ReservationFormBottomSheet> createState() =>
      _ReservationFormBottomSheetState();
}

class _ReservationFormBottomSheetState
    extends State<ReservationFormBottomSheet> {
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  // FocusNodes for validation (Local to UI but still needed for focus loss check)
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _meterPriceFocus = FocusNode();
  final FocusNode _unitAreaFocus = FocusNode();
  final FocusNode _paymentValueFocus = FocusNode();
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _nationalIdFocus = FocusNode();

  late CustomerProvider _customerProvider;
  late ReservationFormProvider _reservationFormProvider;
  bool _isInitialized = false;
  bool _shouldShowForm = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _customerProvider = context.read<CustomerProvider>();
      _reservationFormProvider = context.read<ReservationFormProvider>();

      _customerProvider.addListener(_updateGlobalLoading);
      _reservationFormProvider.addListener(_updateGlobalLoading);

      // Deferred build: wait for bottom sheet animation to complete
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            _shouldShowForm = true;
          });
        }
      });
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();

    // Check initial loading state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateGlobalLoading();
    });
  }

  void _updateGlobalLoading() {
    if (!mounted) return;
    final customerLoading = _customerProvider.isLoading;
    final reservationLoading = _reservationFormProvider.isReserving;

    if (customerLoading || reservationLoading) {
      BotToast.showLoading();
    } else {
      BotToast.closeAllLoading();
    }
  }

  void _setupFocusListeners() {
    final provider = context.read<ReservationFormProvider>();
    _descriptionFocus.addListener(
      () => _validateFocusLoss(
        _descriptionFocus,
        provider.descriptionController,
        'description',
      ),
    );
    _meterPriceFocus.addListener(
      () => _validateFocusLoss(
        _meterPriceFocus,
        provider.meterPriceController,
        'meterPrice',
      ),
    );
    _unitAreaFocus.addListener(
      () => _validateFocusLoss(
        _unitAreaFocus,
        provider.unitAreaController,
        'unitArea',
      ),
    );
    _paymentValueFocus.addListener(
      () => _validateFocusLoss(
        _paymentValueFocus,
        provider.paymentValueController,
        'paymentValue',
      ),
    );
    _mobileNumberFocus.addListener(
      () => _validateFocusLoss(
        _mobileNumberFocus,
        provider.mobileNumberController,
        'mobileNumber',
      ),
    );
    _nationalIdFocus.addListener(
      () => _validateFocusLoss(
        _nationalIdFocus,
        provider.nationalIdController,
        'nationalId',
      ),
    );
  }

  @override
  void dispose() {
    // Remove listeners using stored references safely
    _customerProvider.removeListener(_updateGlobalLoading);
    _reservationFormProvider.removeListener(_updateGlobalLoading);

    _descriptionFocus.dispose();
    _meterPriceFocus.dispose();
    _unitAreaFocus.dispose();
    _paymentValueFocus.dispose();
    _mobileNumberFocus.dispose();
    _nationalIdFocus.dispose();
    super.dispose();
  }

  void _validateFocusLoss(
    FocusNode focusNode,
    TextEditingController controller,
    String field,
  ) {
    if (!focusNode.hasFocus && mounted) {
      final provider = context.read<ReservationFormProvider>();
      if (controller.text.trim().isEmpty) {
        provider.setError(field, AppLocalizations.of(context)!.fieldRequired);
      } else {
        provider.setError(field, null);
      }
    }
  }

  bool _areRequiredFieldsFilled(ReservationFormProvider provider) {
    final hasCustomerInfo =
        (provider.selectedUser != null && provider.selectedUser!.isNotEmpty) ||
        provider.customerNameController.text.trim().isNotEmpty;

    return hasCustomerInfo &&
        provider.meterPriceController.text.trim().isNotEmpty &&
        provider.unitAreaController.text.trim().isNotEmpty &&
        provider.paymentValueController.text.trim().isNotEmpty &&
        provider.totalPriceController.text.trim().isNotEmpty &&
        provider.descriptionController.text.trim().isNotEmpty &&
        provider.mobileNumberController.text.trim().isNotEmpty &&
        provider.nationalIdController.text.trim().isNotEmpty &&
        provider.selectedPaymentType != null;
  }

  double _parseFormatted(String text) {
    return double.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  Future<void> _handleReservation(ReservationFormProvider provider) async {
    if (!_areRequiredFieldsFilled(provider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fillAllFields),
          backgroundColor: ColorManager.soldColor,
        ),
      );
      return;
    }

    provider.setReserving(true);

    try {
      final authState = context.read<AuthCubitCubit>().state;
      final salesCode = authState.userModel?.items?.firstOrNull?.usersCode ?? 0;

      // Convert payment type to integer
      int paymentTypeValue = 1; // Default to installment
      final localizations = AppLocalizations.of(context)!;
      if (provider.selectedPaymentType == localizations.installmentPayment) {
        paymentTypeValue = 1;
      } else if (provider.selectedPaymentType == localizations.cashPayment) {
        paymentTypeValue = 2;
      } else if (provider.selectedPaymentType ==
          localizations.semiCashPayment) {
        paymentTypeValue = 3;
      }

      final response = await widget.homeDatasource.reserveUnit(
        salesCode: salesCode,
        buildingCode: widget.unit.buildingCode ?? 0,
        unitCode: widget.unit.unitCode ?? "",
        customerName: provider.customerNameController.text,
        selectedUser: provider.selectedUser,
        reservationDate: _dateFormatter.format(provider.reservationDate),
        contractDate: _dateFormatter.format(provider.contractDate),
        description: provider.descriptionController.text,
        meterPrice: _parseFormatted(provider.meterPriceController.text),
        unitArea: _parseFormatted(provider.unitAreaController.text),
        totalPrice: _parseFormatted(provider.totalPriceController.text),
        paymentValue: _parseFormatted(provider.paymentValueController.text),
        dueDate: _dateFormatter.format(provider.dueDate),
        mobileNo: provider.mobileNumberController.text,
        nationalId: provider.nationalIdController.text,
        paymentType: paymentTypeValue,
      );

      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        String message = localizations.reservationSuccess;
        bool isSuccess = true;
        String? reservationNumber;

        if (response is DioException) {
          message = _getErrorMessageFromDio(response, localizations);
          isSuccess = false;
        } else if (response is Map<String, dynamic>) {
          if (response['status'] == 'success') {
            message = localizations.reservationSuccess;
            reservationNumber = response['rsrv_no']?.toString();
          } else if (response['message'] == 'Unit is already reserved') {
            message = localizations.unitAlreadyReserved;
            isSuccess = false;
          } else {
            final errorMsg = response['message'] ?? '';
            message = errorMsg.isNotEmpty
                ? errorMsg
                : localizations.reservationError;
            isSuccess = false;
          }
        }

        provider.setReserving(false);
        if (mounted) {
          BotToast.closeAllLoading();
        }

        await _showResultDialog(
          message,
          isSuccess,
          reservationNumber: reservationNumber,
        );

        if (isSuccess || message == localizations.unitAlreadyReserved) {
          if (mounted) {
            Navigator.of(context).pop(); // Close bottom sheet ONLY

            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showResultDialog(
          AppLocalizations.of(context)!.reservationError,
          false,
        );
      }
    } finally {
      // isReserving is already set to false before result dialog
    }
  }

  Widget _buildFormSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  String _getErrorMessageFromDio(DioException error, AppLocalizations l10n) {
    if (error.response != null) {
      if (error.response!.statusCode != null &&
          error.response!.statusCode! >= 500) {
        return l10n.serverError;
      }
      if (error.response!.data is Map<String, dynamic>) {
        return error.response!.data['message'] ?? l10n.reservationError;
      }
    }
    return l10n.reservationError;
  }

  Future<void> _showResultDialog(
    String message,
    bool isSuccess, {
    String? reservationNumber,
  }) async {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: isSuccess
                ? ColorManager.availableColor
                : ColorManager.soldColor,
            width: 1.w,
          ),
        ),
        title: Text(
          isSuccess ? localizations.success : localizations.error,
          style: TextStyle(
            color: isSuccess
                ? ColorManager.availableColor
                : ColorManager.soldColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(color: ColorManager.white),
              textAlign: TextAlign.center,
            ),
            if (isSuccess && reservationNumber != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorManager.availableColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: ColorManager.availableColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isArabic ? 'رقم الحجز: ' : 'Reservation No: ',
                      style: TextStyle(
                        color: ColorManager.white.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      reservationNumber,
                      style: TextStyle(
                        color: ColorManager.availableColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess
                    ? ColorManager.availableColor
                    : ColorManager.soldColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                localizations.ok,
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final provider = context.watch<ReservationFormProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final areFieldsFilled = _areRequiredFieldsFilled(provider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: ColorManager.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.reservationDetails,
                    style: GoogleFonts.poppins(
                      color: ColorManager.availableColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: ColorManager.white,
                      size: 24.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              color: ColorManager.white.withValues(alpha: 0.2),
              height: 1,
            ),
            Expanded(
              child: !_shouldShowForm
                  ? _buildFormSkeleton()
                  : SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UnitDetailLabel(
                            label: localizations.customerNameLabel,
                          ),
                          UnitDetailDropdown(
                            selectedUser: provider.selectedUser,
                            users: customerProvider.customers,
                            onSelected: provider.setSelectedUser,
                            isLoading: customerProvider.isLoading,
                            hint: localizations.customerNameLabel,
                          ),
                          SizedBox(height: 16.h),
                          UnitDetailLabel(
                            label: localizations.customerDescription,
                          ),
                          UnitDetailTextField(
                            controller: provider.customerNameController,
                            hint: localizations.enterName,
                          ),
                          SizedBox(height: 16.h),
                          UnitDetailLabel(
                            label: localizations.mobileNumber,
                            isRequired: true,
                          ),
                          UnitDetailTextField(
                            controller: provider.mobileNumberController,
                            hint: localizations.enterMobileNumber,
                            isNumber: true,
                            errorText: provider.mobileNumberError,
                            focusNode: _mobileNumberFocus,
                          ),
                          SizedBox(height: 16.h),
                          UnitDetailLabel(
                            label: localizations.nationalId,
                            isRequired: true,
                          ),
                          UnitDetailTextField(
                            controller: provider.nationalIdController,
                            hint: localizations.enterNationalId,
                            isNumber: true,
                            errorText: provider.nationalIdError,
                            focusNode: _nationalIdFocus,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.resDate,
                                    ),
                                    UnitDetailDatePicker(
                                      date: provider.reservationDate,
                                      onDateSelected:
                                          provider.setReservationDate,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.contDate,
                                    ),
                                    UnitDetailDatePicker(
                                      date: provider.contractDate,
                                      onDateSelected: provider.setContractDate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          UnitDetailLabel(
                            label: localizations.description,
                            isRequired: true,
                          ),
                          UnitDetailTextField(
                            controller: provider.descriptionController,
                            hint: localizations.notesHint,
                            maxLines: 3,
                            errorText: provider.descriptionError,
                            focusNode: _descriptionFocus,
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.meterPrice,
                                      isRequired: true,
                                    ),
                                    UnitDetailTextField(
                                      controller: provider.meterPriceController,
                                      isNumber: true,
                                      formatters: [
                                        ThousandsSeparatorInputFormatter(),
                                      ],
                                      errorText: provider.meterPriceError,
                                      focusNode: _meterPriceFocus,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 25.h,
                                  left: 5.w,
                                  right: 5.w,
                                ),
                                child: Text(
                                  "✕",
                                  style: TextStyle(
                                    color: ColorManager.availableColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.unitArea,
                                      isRequired: true,
                                    ),
                                    UnitDetailTextField(
                                      controller: provider.unitAreaController,
                                      isNumber: true,
                                      formatters: [
                                        ThousandsSeparatorInputFormatter(),
                                      ],
                                      errorText: provider.unitAreaError,
                                      focusNode: _unitAreaFocus,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Divider(
                            color: ColorManager.white.withValues(alpha: 0.2),
                          ),
                          UnitDetailLabel(label: localizations.totalPriceAuto),
                          UnitDetailTextField(
                            controller: provider.totalPriceController,
                            enabled: false,
                            suffix: isArabic ? "ج.م" : "EGP",
                            color: ColorManager.availableColor,
                          ),
                          SizedBox(height: 16.h),
                          UnitDetailLabel(
                            label: localizations.paymentType,
                            isRequired: true,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorManager.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorManager.white.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1.w,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: provider.selectedPaymentType,
                                hint: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                  ),
                                  child: Text(
                                    localizations.selectPaymentType,
                                    style: TextStyle(
                                      color: ColorManager.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                dropdownColor: ColorManager.black,
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: ColorManager.availableColor,
                                  ),
                                ),
                                items:
                                    [
                                      localizations.installmentPayment,
                                      localizations.cashPayment,
                                      localizations.semiCashPayment,
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: ColorManager.white,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: provider.setSelectedPaymentType,
                              ),
                            ),
                          ),
                          Divider(
                            color: ColorManager.white.withValues(alpha: 0.2),
                            height: 40.h,
                          ),
                          Text(
                            localizations.userInput,
                            style: GoogleFonts.poppins(
                              color: ColorManager.availableColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.payValue,
                                      isRequired: true,
                                    ),
                                    UnitDetailTextField(
                                      controller:
                                          provider.paymentValueController,
                                      isNumber: true,
                                      formatters: [
                                        ThousandsSeparatorInputFormatter(),
                                      ],
                                      errorText: provider.paymentValueError,
                                      focusNode: _paymentValueFocus,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UnitDetailLabel(
                                      label: localizations.dueDate,
                                    ),
                                    UnitDetailDatePicker(
                                      date: provider.dueDate,
                                      onDateSelected: provider.setDueDate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
            ),
            if (_shouldShowForm)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: ColorManager.black,
                  border: Border(
                    top: BorderSide(
                      color: ColorManager.white.withValues(alpha: 0.2),
                      width: 1.w,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: areFieldsFilled && !provider.isReserving
                        ? () => _handleReservation(provider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: areFieldsFilled
                          ? ColorManager.availableColor
                          : ColorManager.availableColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      disabledBackgroundColor: ColorManager.availableColor
                          .withOpacity(0.3),
                    ),
                    child: Text(
                      localizations.reserve,
                      style: TextStyle(
                        color: areFieldsFilled
                            ? ColorManager.white
                            : ColorManager.white.withValues(alpha: 0.7),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
