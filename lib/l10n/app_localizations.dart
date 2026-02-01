import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @userCode.
  ///
  /// In en, this message translates to:
  /// **'User Code'**
  String get userCode;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @userCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter user code'**
  String get userCodeHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// No description provided for @userCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'User code is required'**
  String get userCodeRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @logoText.
  ///
  /// In en, this message translates to:
  /// **'Arab Investors \n for Projects management'**
  String get logoText;

  /// No description provided for @propertyBooking.
  ///
  /// In en, this message translates to:
  /// **'Property Booking'**
  String get propertyBooking;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get loginError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid user code or password'**
  String get invalidCredentials;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User code not found'**
  String get userNotFound;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @propertyManager.
  ///
  /// In en, this message translates to:
  /// **'Property Manager'**
  String get propertyManager;

  /// No description provided for @availableZones.
  ///
  /// In en, this message translates to:
  /// **'Available Zones'**
  String get availableZones;

  /// No description provided for @errorLoadingZones.
  ///
  /// In en, this message translates to:
  /// **'Error loading zones'**
  String get errorLoadingZones;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noZonesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No zones available'**
  String get noZonesAvailable;

  /// No description provided for @checkBackLaterForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check back later for updates'**
  String get checkBackLaterForUpdates;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @errorLoadingProjects.
  ///
  /// In en, this message translates to:
  /// **'Error loading projects'**
  String get errorLoadingProjects;

  /// No description provided for @noProjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No projects available'**
  String get noProjectsAvailable;

  /// No description provided for @noProjectsFoundInZone.
  ///
  /// In en, this message translates to:
  /// **'No projects found in this zone'**
  String get noProjectsFoundInZone;

  /// No description provided for @unknownZone.
  ///
  /// In en, this message translates to:
  /// **'Unknown Zone'**
  String get unknownZone;

  /// No description provided for @zoneCode.
  ///
  /// In en, this message translates to:
  /// **'Zone Code: '**
  String get zoneCode;

  /// No description provided for @unknownProject.
  ///
  /// In en, this message translates to:
  /// **'Unknown Project'**
  String get unknownProject;

  /// No description provided for @projectCode.
  ///
  /// In en, this message translates to:
  /// **'Project Code: '**
  String get projectCode;

  /// No description provided for @unitDetails.
  ///
  /// In en, this message translates to:
  /// **'Unit Details'**
  String get unitDetails;

  /// No description provided for @buildingName.
  ///
  /// In en, this message translates to:
  /// **'Building Name'**
  String get buildingName;

  /// No description provided for @modelName.
  ///
  /// In en, this message translates to:
  /// **'Model Name'**
  String get modelName;

  /// No description provided for @installment.
  ///
  /// In en, this message translates to:
  /// **'Installment \'EGP\''**
  String get installment;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price \'EGP\''**
  String get totalPrice;

  /// No description provided for @levelNo.
  ///
  /// In en, this message translates to:
  /// **'Level No'**
  String get levelNo;

  /// No description provided for @flatNo.
  ///
  /// In en, this message translates to:
  /// **'Unit No'**
  String get flatNo;

  /// No description provided for @unitStatus.
  ///
  /// In en, this message translates to:
  /// **'Unit Status'**
  String get unitStatus;

  /// No description provided for @meterPrice.
  ///
  /// In en, this message translates to:
  /// **'Meter Price \'EGP\''**
  String get meterPrice;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Not Available Now'**
  String get notAvailableNow;

  /// No description provided for @partnerUnit.
  ///
  /// In en, this message translates to:
  /// **'Partner Unit'**
  String get partnerUnit;

  /// No description provided for @installmentValue.
  ///
  /// In en, this message translates to:
  /// **'Installment Value'**
  String get installmentValue;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @unitArea.
  ///
  /// In en, this message translates to:
  /// **'Unit Area \'meter\''**
  String get unitArea;

  /// No description provided for @fullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full Description'**
  String get fullDescription;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @reservationDetails.
  ///
  /// In en, this message translates to:
  /// **'Reservation Details'**
  String get reservationDetails;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerNameLabel;

  /// No description provided for @customerDescription.
  ///
  /// In en, this message translates to:
  /// **'Customer Description'**
  String get customerDescription;

  /// No description provided for @resDate.
  ///
  /// In en, this message translates to:
  /// **'Res. Date'**
  String get resDate;

  /// No description provided for @contDate.
  ///
  /// In en, this message translates to:
  /// **'Cont. Date'**
  String get contDate;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes...'**
  String get notesHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @totalPriceAuto.
  ///
  /// In en, this message translates to:
  /// **'Total Price EGP'**
  String get totalPriceAuto;

  /// No description provided for @userInput.
  ///
  /// In en, this message translates to:
  /// **'User Input'**
  String get userInput;

  /// No description provided for @payValue.
  ///
  /// In en, this message translates to:
  /// **'Pay Value \'EGP\''**
  String get payValue;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @noUnitsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No units available'**
  String get noUnitsAvailable;

  /// No description provided for @noUnitsFoundInBuilding.
  ///
  /// In en, this message translates to:
  /// **'No units found in this building'**
  String get noUnitsFoundInBuilding;

  /// No description provided for @errorLoadingUnits.
  ///
  /// In en, this message translates to:
  /// **'Error loading units'**
  String get errorLoadingUnits;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @selectUser.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get selectUser;

  /// No description provided for @reservationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reservation created successfully'**
  String get reservationSuccess;

  /// No description provided for @reservationError.
  ///
  /// In en, this message translates to:
  /// **'Reservation failed'**
  String get reservationError;

  /// No description provided for @unitAlreadyReserved.
  ///
  /// In en, this message translates to:
  /// **'Unit is already reserved'**
  String get unitAlreadyReserved;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error. Please try again later.'**
  String get serverError;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill all Fields'**
  String get fillAllFields;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
