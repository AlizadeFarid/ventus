import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('az'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ventus'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeToVentus.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ventus'**
  String get welcomeToVentus;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String greeting(String name);

  /// No description provided for @yourTrips.
  ///
  /// In en, this message translates to:
  /// **'Your trips'**
  String get yourTrips;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @allTrips.
  ///
  /// In en, this message translates to:
  /// **'All trips'**
  String get allTrips;

  /// No description provided for @tripsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tripsUpcoming;

  /// No description provided for @tripsPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tripsPast;

  /// No description provided for @allTripsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your planned and past trips will show up here.'**
  String get allTripsEmptyBody;

  /// No description provided for @sharedViaVentus.
  ///
  /// In en, this message translates to:
  /// **'Planned with Ventus ✈️'**
  String get sharedViaVentus;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @sponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get sponsored;

  /// No description provided for @planWithAi.
  ///
  /// In en, this message translates to:
  /// **'Plan with AI'**
  String get planWithAi;

  /// No description provided for @planWithAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell me where you’re going next'**
  String get planWithAiSubtitle;

  /// No description provided for @whereToFirst.
  ///
  /// In en, this message translates to:
  /// **'Where to first?'**
  String get whereToFirst;

  /// No description provided for @emptyHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Write the route by hand, or describe it in a sentence and let AI build it.'**
  String get emptyHomeBody;

  /// No description provided for @planNewTrip.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get planNewTrip;

  /// No description provided for @tripDaysToGo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day to go} other{{count} days to go}}'**
  String tripDaysToGo(int count);

  /// No description provided for @tripToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tripToday;

  /// No description provided for @tripInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tripInProgress;

  /// No description provided for @percentPlanned.
  ///
  /// In en, this message translates to:
  /// **'{percent}% planned'**
  String percentPlanned(int percent);

  /// No description provided for @tripStartPlanning.
  ///
  /// In en, this message translates to:
  /// **'Start planning'**
  String get tripStartPlanning;

  /// No description provided for @couldNotLoadTrips.
  ///
  /// In en, this message translates to:
  /// **'Could not load your trips.'**
  String get couldNotLoadTrips;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutTitle;

  /// No description provided for @signOutBody.
  ///
  /// In en, this message translates to:
  /// **'You can sign back in any time.'**
  String get signOutBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @setPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get setPasswordTitle;

  /// No description provided for @setPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get setPasswordAction;

  /// No description provided for @setPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'You signed in with Google, so your account has no password yet. Set one and you\'ll be able to sign in with your email too.'**
  String get setPasswordNote;

  /// No description provided for @passwordSet.
  ///
  /// In en, this message translates to:
  /// **'Password set.'**
  String get passwordSet;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @notificationsTitleShort.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitleShort;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — changes sync when you\'re back.'**
  String get offlineBanner;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @savedAdd.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get savedAdd;

  /// No description provided for @savedRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get savedRemove;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get somethingWentWrong;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeTripSoon.
  ///
  /// In en, this message translates to:
  /// **'Your trip is coming up'**
  String get homeTripSoon;

  /// No description provided for @homeTripToday.
  ///
  /// In en, this message translates to:
  /// **'You leave today'**
  String get homeTripToday;

  /// No description provided for @homeTripOngoing.
  ///
  /// In en, this message translates to:
  /// **'Trip in progress'**
  String get homeTripOngoing;

  /// No description provided for @homeWhereTo.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get homeWhereTo;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get homeSearchHint;

  /// No description provided for @createSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get createSheetTitle;

  /// No description provided for @createSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to start?'**
  String get createSheetSubtitle;

  /// No description provided for @createAiBadge.
  ///
  /// In en, this message translates to:
  /// **'FAST'**
  String get createAiBadge;

  /// No description provided for @createAiBody.
  ///
  /// In en, this message translates to:
  /// **'Write \"4 days in Rome in October, museums and food\" — get an instant plan.'**
  String get createAiBody;

  /// No description provided for @createManualBody.
  ///
  /// In en, this message translates to:
  /// **'Pick the destination, dates and travel companions yourself.'**
  String get createManualBody;

  /// No description provided for @sheetClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sheetClose;

  /// No description provided for @tripPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'My trips'**
  String get tripPickerTitle;

  /// No description provided for @addNewTripShort.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get addNewTripShort;

  /// No description provided for @emptyHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your next trip'**
  String get emptyHomeTitle;

  /// No description provided for @toolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Handy on the road · works offline'**
  String get toolsSubtitle;

  /// No description provided for @toolCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency converter'**
  String get toolCurrency;

  /// No description provided for @toolWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get toolWeather;

  /// No description provided for @toolWorldClock.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get toolWorldClock;

  /// No description provided for @toolTip.
  ///
  /// In en, this message translates to:
  /// **'Tip calculator'**
  String get toolTip;

  /// No description provided for @toolsSectionWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather & time'**
  String get toolsSectionWeather;

  /// No description provided for @toolsSectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get toolsSectionMoney;

  /// No description provided for @toolsOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load. Check your connection.'**
  String get toolsOffline;

  /// No description provided for @clockHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get clockHome;

  /// No description provided for @clockBehindHome.
  ///
  /// In en, this message translates to:
  /// **'{hours} h behind home'**
  String clockBehindHome(String hours);

  /// No description provided for @clockAheadOfHome.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ahead of home'**
  String clockAheadOfHome(String hours);

  /// No description provided for @clockSameAsHome.
  ///
  /// In en, this message translates to:
  /// **'Same time as home'**
  String get clockSameAsHome;

  /// No description provided for @clockSameShort.
  ///
  /// In en, this message translates to:
  /// **'Same'**
  String get clockSameShort;

  /// No description provided for @clockYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get clockYesterday;

  /// No description provided for @clockHourShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get clockHourShort;

  /// No description provided for @clockCityRemoved.
  ///
  /// In en, this message translates to:
  /// **'City removed'**
  String get clockCityRemoved;

  /// No description provided for @currencyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String currencyUpdated(Object date);

  /// No description provided for @curUSD.
  ///
  /// In en, this message translates to:
  /// **'US dollar'**
  String get curUSD;

  /// No description provided for @curEUR.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get curEUR;

  /// No description provided for @curGBP.
  ///
  /// In en, this message translates to:
  /// **'British pound'**
  String get curGBP;

  /// No description provided for @curTRY.
  ///
  /// In en, this message translates to:
  /// **'Turkish lira'**
  String get curTRY;

  /// No description provided for @curAZN.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijani manat'**
  String get curAZN;

  /// No description provided for @curAED.
  ///
  /// In en, this message translates to:
  /// **'UAE dirham'**
  String get curAED;

  /// No description provided for @curGEL.
  ///
  /// In en, this message translates to:
  /// **'Georgian lari'**
  String get curGEL;

  /// No description provided for @toolsActiveTripBanner.
  ///
  /// In en, this message translates to:
  /// **'Active trip: {trip}'**
  String toolsActiveTripBanner(Object trip);

  /// No description provided for @toolsCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'1 {fromGlyph} = {rate} {toGlyph} · {when}'**
  String toolsCurrencyHint(
    Object fromGlyph,
    Object rate,
    Object toGlyph,
    Object when,
  );

  /// No description provided for @toolsRateToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get toolsRateToday;

  /// No description provided for @toolsTimezoneHint.
  ///
  /// In en, this message translates to:
  /// **'{away} · {hours}h difference'**
  String toolsTimezoneHint(Object hours, Object away);

  /// No description provided for @toolsTimezoneEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add a city to compare times'**
  String get toolsTimezoneEmptyHint;

  /// No description provided for @toolsWeatherHint.
  ///
  /// In en, this message translates to:
  /// **'{temp}° · {city}'**
  String toolsWeatherHint(Object temp, Object city);

  /// No description provided for @currencyAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount to convert'**
  String get currencyAmountLabel;

  /// No description provided for @currencyConvertedLabel.
  ///
  /// In en, this message translates to:
  /// **'Converted amount'**
  String get currencyConvertedLabel;

  /// No description provided for @currencyRateLine.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {rate} {to}'**
  String currencyRateLine(Object from, Object rate, Object to);

  /// No description provided for @currencyRateSourceMarket.
  ///
  /// In en, this message translates to:
  /// **'Market rate · {date}'**
  String currencyRateSourceMarket(Object date);

  /// No description provided for @currencyRateSource.
  ///
  /// In en, this message translates to:
  /// **'Central Bank of Azerbaijan official rate · {date}'**
  String currencyRateSource(Object date);

  /// No description provided for @quickAmountsLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick amounts'**
  String get quickAmountsLabel;

  /// No description provided for @addToBudgetAsExpense.
  ///
  /// In en, this message translates to:
  /// **'Add to budget as an expense'**
  String get addToBudgetAsExpense;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your trip budget.'**
  String get expenseAdded;

  /// No description provided for @currencyPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a currency'**
  String get currencyPickerTitle;

  /// No description provided for @currencySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search currency or country'**
  String get currencySearchHint;

  /// No description provided for @currencyAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All currencies'**
  String get currencyAllLabel;

  /// No description provided for @currencyHomeCurrency.
  ///
  /// In en, this message translates to:
  /// **'Home currency'**
  String get currencyHomeCurrency;

  /// No description provided for @currencyTripCurrency.
  ///
  /// In en, this message translates to:
  /// **'Active trip currency'**
  String get currencyTripCurrency;

  /// No description provided for @timezoneTripTag.
  ///
  /// In en, this message translates to:
  /// **'active trip'**
  String get timezoneTripTag;

  /// No description provided for @tipOtherPercent.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get tipOtherPercent;

  /// No description provided for @tipCustomPercentHint.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get tipCustomPercentHint;

  /// No description provided for @weatherToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get weatherToday;

  /// No description provided for @weatherNextDays.
  ///
  /// In en, this message translates to:
  /// **'Next 5 days'**
  String get weatherNextDays;

  /// No description provided for @weatherNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get weatherNow;

  /// No description provided for @weatherTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get weatherTomorrow;

  /// No description provided for @weatherFeelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get weatherFeelsLike;

  /// No description provided for @weatherWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get weatherWind;

  /// No description provided for @weatherHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get weatherHumidity;

  /// No description provided for @weatherRainChance.
  ///
  /// In en, this message translates to:
  /// **'Chance of rain'**
  String get weatherRainChance;

  /// No description provided for @weatherSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get weatherSunrise;

  /// No description provided for @weatherSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get weatherSunset;

  /// No description provided for @weatherWindKmh.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String weatherWindKmh(String value);

  /// No description provided for @weatherWindMph.
  ///
  /// In en, this message translates to:
  /// **'{value} mph'**
  String weatherWindMph(String value);

  /// No description provided for @wxClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get wxClear;

  /// No description provided for @wxPartly.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get wxPartly;

  /// No description provided for @wxCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get wxCloudy;

  /// No description provided for @wxFog.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get wxFog;

  /// No description provided for @wxDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get wxDrizzle;

  /// No description provided for @wxRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get wxRain;

  /// No description provided for @wxSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get wxSnow;

  /// No description provided for @wxStorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get wxStorm;

  /// No description provided for @tipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick gratuity · offline'**
  String get tipSubtitle;

  /// No description provided for @tipTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get tipTotal;

  /// No description provided for @tipAmount.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tipAmount;

  /// No description provided for @tipPerPerson.
  ///
  /// In en, this message translates to:
  /// **'Per person'**
  String get tipPerPerson;

  /// No description provided for @tipBillLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill amount'**
  String get tipBillLabel;

  /// No description provided for @tipPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tipPercentLabel;

  /// No description provided for @tipSplitLabel.
  ///
  /// In en, this message translates to:
  /// **'Split between'**
  String get tipSplitLabel;

  /// No description provided for @tipExampleBill.
  ///
  /// In en, this message translates to:
  /// **'Bill {glyph}0 · 0%'**
  String tipExampleBill(String glyph);

  /// No description provided for @tipPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} person} other{{count} people}}'**
  String tipPeopleCount(num count);

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search a city'**
  String get searchCity;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Type a city name…'**
  String get searchCityHint;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found.'**
  String get noCitiesFound;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get exploreTitle;

  /// No description provided for @exploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Places to inspire you'**
  String get exploreSubtitle;

  /// No description provided for @exploreAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask Ventus'**
  String get exploreAsk;

  /// No description provided for @exploreEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to explore yet.'**
  String get exploreEmpty;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a city or country'**
  String get exploreSearchHint;

  /// No description provided for @exploreNoMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matched \"{query}\".'**
  String exploreNoMatches(Object query);

  /// No description provided for @exploreCuratedSection.
  ///
  /// In en, this message translates to:
  /// **'In Ventus'**
  String get exploreCuratedSection;

  /// No description provided for @exploreOtherPlacesSection.
  ///
  /// In en, this message translates to:
  /// **'Other places'**
  String get exploreOtherPlacesSection;

  /// No description provided for @exploreSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get exploreSearching;

  /// No description provided for @exploreStartTripHere.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip here'**
  String get exploreStartTripHere;

  /// No description provided for @savedTitleShort.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitleShort;

  /// No description provided for @planTripHere.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip here'**
  String get planTripHere;

  /// No description provided for @factCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get factCurrency;

  /// No description provided for @factLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get factLanguage;

  /// No description provided for @factBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best time'**
  String get factBestTime;

  /// No description provided for @factTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get factTimezone;

  /// No description provided for @destGoodToKnow.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get destGoodToKnow;

  /// No description provided for @destAskPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan with Ventus'**
  String get destAskPlan;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get readLess;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved places yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on places you like in Discover.'**
  String get savedEmptyBody;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'YOUR AI TRAVEL COMPANION'**
  String get welcomeTagline;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Every journey,\nbeautifully planned.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Itinerary, budget, documents and tickets — together in one calm place.'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get haveAccount;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey.'**
  String get signInSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get forgot;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInAction;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @newToVentus.
  ///
  /// In en, this message translates to:
  /// **'New to Ventus?'**
  String get newToVentus;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountAction;

  /// No description provided for @providerComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{provider} sign-in is coming soon.'**
  String providerComingSoon(String provider);

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Ventus and plan your next trip.'**
  String get createAccountSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fullNameHint;

  /// No description provided for @passwordHintMin.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHintMin;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @agreeTermsRich.
  ///
  /// In en, this message translates to:
  /// **'I agree to the [terms] and [privacy].'**
  String get agreeTermsRich;

  /// No description provided for @termsLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsLinkLabel;

  /// No description provided for @privacyLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyLinkLabel;

  /// No description provided for @acceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Accept the Terms & Privacy Policy to continue.'**
  String get acceptTermsError;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotTitle;

  /// No description provided for @forgotBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email linked to your account and we’ll send you a reset code.'**
  String get forgotBody;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendResetLink;

  /// No description provided for @resetSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent. Check your inbox.'**
  String get resetSent;

  /// No description provided for @rememberedIt.
  ///
  /// In en, this message translates to:
  /// **'Remembered it?'**
  String get rememberedIt;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Tap it to verify your account, then come back to sign in.'**
  String verifyEmailBody(String email);

  /// No description provided for @verifyEmailSpamNote.
  ///
  /// In en, this message translates to:
  /// **'Didn’t get it? Check your spam folder or resend.'**
  String get verifyEmailSpamNote;

  /// No description provided for @verifyEmailResend.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent. Check your inbox.'**
  String get verifyEmailResent;

  /// No description provided for @verifyEmailSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to sign in'**
  String get verifyEmailSignIn;

  /// No description provided for @resetCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get resetCodeTitle;

  /// No description provided for @resetCodeBody.
  ///
  /// In en, this message translates to:
  /// **'We emailed a 6-digit code to {email}. Enter it below and choose a new password.'**
  String resetCodeBody(String email);

  /// No description provided for @resetCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset code'**
  String get resetCodeLabel;

  /// No description provided for @resetCodeHint.
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get resetCodeHint;

  /// No description provided for @resetSubmit.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetSubmit;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. You’re all set.'**
  String get resetSuccess;

  /// No description provided for @resetResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resetResend;

  /// No description provided for @resetResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get resetResent;

  /// No description provided for @authInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect or has expired.'**
  String get authInvalidOtp;

  /// No description provided for @authRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in a few minutes.'**
  String get authRateLimited;

  /// No description provided for @legalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: June 2026'**
  String get legalUpdated;

  /// No description provided for @legalContact.
  ///
  /// In en, this message translates to:
  /// **'Questions about these terms or your data? Contact us at support@ventus.app.'**
  String get legalContact;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get legalTermsTitle;

  /// No description provided for @legalTermsIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ventus. By creating an account and using the app, you agree to these Terms. If you do not agree, please do not use Ventus.'**
  String get legalTermsIntro;

  /// No description provided for @legalTermsS1Title.
  ///
  /// In en, this message translates to:
  /// **'Using Ventus'**
  String get legalTermsS1Title;

  /// No description provided for @legalTermsS1Body.
  ///
  /// In en, this message translates to:
  /// **'Ventus helps you plan and organize trips. Use it only for lawful, personal purposes, and do not misuse, copy, or try to disrupt the service. AI-generated plans and suggestions are for guidance only — always verify times, prices, visas, and bookings yourself.'**
  String get legalTermsS1Body;

  /// No description provided for @legalTermsS2Title.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get legalTermsS2Title;

  /// No description provided for @legalTermsS2Body.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for keeping your email, password, and PIN secure, and for all activity on your account. Let us know right away if you notice any unauthorized use.'**
  String get legalTermsS2Body;

  /// No description provided for @legalTermsS3Title.
  ///
  /// In en, this message translates to:
  /// **'Your content'**
  String get legalTermsS3Title;

  /// No description provided for @legalTermsS3Body.
  ///
  /// In en, this message translates to:
  /// **'Trips, notes, files, and other content you add remain yours. You grant Ventus permission to store, sync, and process this content solely to provide the app\'s features to you.'**
  String get legalTermsS3Body;

  /// No description provided for @legalTermsS4Title.
  ///
  /// In en, this message translates to:
  /// **'Service & liability'**
  String get legalTermsS4Title;

  /// No description provided for @legalTermsS4Body.
  ///
  /// In en, this message translates to:
  /// **'Ventus is provided “as is”, without warranties. We may add, change, or remove features, and we are not liable for losses arising from third-party data (maps, weather, AI) or interruptions to the service.'**
  String get legalTermsS4Body;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyIntro.
  ///
  /// In en, this message translates to:
  /// **'This policy explains what information Ventus collects, how we use it, and the choices you have.'**
  String get legalPrivacyIntro;

  /// No description provided for @legalPrivacyS1Title.
  ///
  /// In en, this message translates to:
  /// **'What we collect'**
  String get legalPrivacyS1Title;

  /// No description provided for @legalPrivacyS1Body.
  ///
  /// In en, this message translates to:
  /// **'Account details (your name and email) and the trip data you create — destinations, itineraries, checklists, budgets, documents, and saved places. Your PIN is stored only on your device and is never sent to our servers.'**
  String get legalPrivacyS1Body;

  /// No description provided for @legalPrivacyS2Title.
  ///
  /// In en, this message translates to:
  /// **'How we use it'**
  String get legalPrivacyS2Title;

  /// No description provided for @legalPrivacyS2Body.
  ///
  /// In en, this message translates to:
  /// **'To run your account, sync your trips across devices, and power features like AI planning. When you generate a plan, the relevant trip details are sent to our AI provider (Google Gemini) to create it. We never sell your data.'**
  String get legalPrivacyS2Body;

  /// No description provided for @legalPrivacyS3Title.
  ///
  /// In en, this message translates to:
  /// **'Storage & security'**
  String get legalPrivacyS3Title;

  /// No description provided for @legalPrivacyS3Body.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely with our backend provider (Supabase) and encrypted in transit. Map, weather, and currency features query third-party services with only the data needed to answer your request.'**
  String get legalPrivacyS3Body;

  /// No description provided for @legalPrivacyS4Title.
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get legalPrivacyS4Title;

  /// No description provided for @legalPrivacyS4Body.
  ///
  /// In en, this message translates to:
  /// **'You can view and edit your profile, change your password or PIN, and request deletion of your account and data at any time from Settings.'**
  String get legalPrivacyS4Body;

  /// No description provided for @createPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN'**
  String get createPinTitle;

  /// No description provided for @createPinBody.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-digit code for quick, secure access next time.'**
  String get createPinBody;

  /// No description provided for @enterPinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to unlock'**
  String get enterPinToUnlock;

  /// No description provided for @usePasswordInstead.
  ///
  /// In en, this message translates to:
  /// **'Use password instead'**
  String get usePasswordInstead;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN.'**
  String get incorrectPin;

  /// No description provided for @errEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get errEmailRequired;

  /// No description provided for @errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get errPasswordRequired;

  /// No description provided for @errPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get errPasswordTooShort;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get errNameRequired;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Sign in instead.'**
  String get authEmailExists;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox to confirm your email, then sign in.'**
  String get authEmailNotConfirmed;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @avatarTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get avatarTakePhoto;

  /// No description provided for @avatarChooseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get avatarChooseLibrary;

  /// No description provided for @avatarRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get avatarRemove;

  /// No description provided for @emailReadonlyNote.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be changed here.'**
  String get emailReadonlyNote;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Try again.'**
  String get profileSaveFailed;

  /// No description provided for @profileEditUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sign in to edit your profile.'**
  String get profileEditUnavailable;

  /// No description provided for @measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurementSystem;

  /// No description provided for @unitMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get unitMetric;

  /// No description provided for @unitMetricDesc.
  ///
  /// In en, this message translates to:
  /// **'Kilometres, °C'**
  String get unitMetricDesc;

  /// No description provided for @unitImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get unitImperial;

  /// No description provided for @unitImperialDesc.
  ///
  /// In en, this message translates to:
  /// **'Miles, °F'**
  String get unitImperialDesc;

  /// No description provided for @collaboratorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get collaboratorsTitle;

  /// No description provided for @collaboratorsManageSub.
  ///
  /// In en, this message translates to:
  /// **'Invite people to plan together'**
  String get collaboratorsManageSub;

  /// No description provided for @collabPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String collabPeopleCount(int count);

  /// No description provided for @collabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get collabPending;

  /// No description provided for @collabRemoved.
  ///
  /// In en, this message translates to:
  /// **'Collaborator removed'**
  String get collabRemoved;

  /// No description provided for @collabAnyoneWithLink.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link'**
  String get collabAnyoneWithLink;

  /// No description provided for @collabCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get collabCopy;

  /// No description provided for @collabLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied'**
  String get collabLinkCopied;

  /// No description provided for @collabYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get collabYou;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get roleEditor;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @roleEditorDesc.
  ///
  /// In en, this message translates to:
  /// **'Add & edit itinerary, budget, docs'**
  String get roleEditorDesc;

  /// No description provided for @roleViewerDesc.
  ///
  /// In en, this message translates to:
  /// **'See the trip, can’t make changes'**
  String get roleViewerDesc;

  /// No description provided for @collabInviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent · pending'**
  String get collabInviteSent;

  /// No description provided for @removeCollaborator.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeCollaborator;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite to trip'**
  String get inviteTitle;

  /// No description provided for @inviteRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get inviteRoleLabel;

  /// No description provided for @inviteEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get inviteEmailInvalid;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get sendInvite;

  /// No description provided for @collabInviteSentToast.
  ///
  /// In en, this message translates to:
  /// **'Invite sent'**
  String get collabInviteSentToast;

  /// No description provided for @collabPickTrip.
  ///
  /// In en, this message translates to:
  /// **'Choose a trip'**
  String get collabPickTrip;

  /// No description provided for @collabNoTrips.
  ///
  /// In en, this message translates to:
  /// **'Create a trip first to invite people.'**
  String get collabNoTrips;

  /// No description provided for @statCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get statCountries;

  /// No description provided for @statCities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get statCities;

  /// No description provided for @statKmFlown.
  ///
  /// In en, this message translates to:
  /// **'km flown'**
  String get statKmFlown;

  /// No description provided for @statTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get statTrips;

  /// No description provided for @goVentusPro.
  ///
  /// In en, this message translates to:
  /// **'Go Ventus Pro'**
  String get goVentusPro;

  /// No description provided for @goVentusProSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited trips, offline maps & more'**
  String get goVentusProSub;

  /// No description provided for @menuCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get menuCollaborators;

  /// No description provided for @menuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get menuNotifications;

  /// No description provided for @menuSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get menuSavedPlaces;

  /// No description provided for @menuCurrencyUnits.
  ///
  /// In en, this message translates to:
  /// **'Currency & units'**
  String get menuCurrencyUnits;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get menuSettings;

  /// No description provided for @menuPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & security'**
  String get menuPrivacySecurity;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileSectionPreferences;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @whereTo.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get whereTo;

  /// No description provided for @destinationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one or more places — Ventus plans the route between them.'**
  String get destinationSubtitle;

  /// No description provided for @searchCityCountry.
  ///
  /// In en, this message translates to:
  /// **'Search a city or country'**
  String get searchCityCountry;

  /// No description provided for @popularRightNow.
  ///
  /// In en, this message translates to:
  /// **'Popular right now'**
  String get popularRightNow;

  /// No description provided for @addAnotherStop.
  ///
  /// In en, this message translates to:
  /// **'Add another stop'**
  String get addAnotherStop;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular destinations'**
  String get popularDestinations;

  /// No description provided for @placesMatch.
  ///
  /// In en, this message translates to:
  /// **'{count} places match “{query}”'**
  String placesMatch(int count, String query);

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add “{name}”'**
  String addPlace(String name);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @searchingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searchingPlaces;

  /// No description provided for @keepTyping.
  ///
  /// In en, this message translates to:
  /// **'Type at least 3 letters to search'**
  String get keepTyping;

  /// No description provided for @searchPlacesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t search — add it manually below.'**
  String get searchPlacesFailed;

  /// No description provided for @aiTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell Ventus about your trip'**
  String get aiTitle;

  /// No description provided for @aiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your trip in your own words — Ventus fills in the details.'**
  String get aiSubtitle;

  /// No description provided for @aiPromptHint.
  ///
  /// In en, this message translates to:
  /// **'A 5-day food & culture trip to Istanbul and Cappadocia for two, mid-June.'**
  String get aiPromptHint;

  /// No description provided for @aiExamplesLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get aiExamplesLabel;

  /// No description provided for @aiExampleRomanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Romantic weekend'**
  String get aiExampleRomanticLabel;

  /// No description provided for @aiExampleRomanticText.
  ///
  /// In en, this message translates to:
  /// **'A short romantic getaway for two this weekend, somewhere nearby.'**
  String get aiExampleRomanticText;

  /// No description provided for @aiExampleFamilyLabel.
  ///
  /// In en, this message translates to:
  /// **'Family getaway'**
  String get aiExampleFamilyLabel;

  /// No description provided for @aiExampleFamilyText.
  ///
  /// In en, this message translates to:
  /// **'A 7-day beach holiday in August with our family (2 adults, 2 kids).'**
  String get aiExampleFamilyText;

  /// No description provided for @aiExampleFriendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip with friends'**
  String get aiExampleFriendsLabel;

  /// No description provided for @aiExampleFriendsText.
  ///
  /// In en, this message translates to:
  /// **'A 3-day mountain trip with 4 friends in September, hiking and nature.'**
  String get aiExampleFriendsText;

  /// No description provided for @aiExampleSoloLabel.
  ///
  /// In en, this message translates to:
  /// **'Solo trip'**
  String get aiExampleSoloLabel;

  /// No description provided for @aiExampleSoloText.
  ///
  /// In en, this message translates to:
  /// **'A solo 4-day culture-and-relax trip to a quiet city in October.'**
  String get aiExampleSoloText;

  /// No description provided for @aiExampleCityLabel.
  ///
  /// In en, this message translates to:
  /// **'Short city break'**
  String get aiExampleCityLabel;

  /// No description provided for @aiExampleCityText.
  ///
  /// In en, this message translates to:
  /// **'A short 3-day weekend city break — historic sights and local food.'**
  String get aiExampleCityText;

  /// No description provided for @aiExampleWinterLabel.
  ///
  /// In en, this message translates to:
  /// **'Winter holiday'**
  String get aiExampleWinterLabel;

  /// No description provided for @aiExampleWinterText.
  ///
  /// In en, this message translates to:
  /// **'A 5-day winter holiday at a snowy mountain resort in January, skiing and hot chocolate.'**
  String get aiExampleWinterText;

  /// No description provided for @ventusUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Ventus understood'**
  String get ventusUnderstood;

  /// No description provided for @whosComing.
  ///
  /// In en, this message translates to:
  /// **'Who’s coming?'**
  String get whosComing;

  /// No description provided for @travelersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps Ventus set the right pace and suggestions.'**
  String get travelersSubtitle;

  /// No description provided for @travelerSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get travelerSolo;

  /// No description provided for @travelerCouple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get travelerCouple;

  /// No description provided for @travelerFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get travelerFamily;

  /// No description provided for @travelerFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get travelerFriends;

  /// No description provided for @travelersAdults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get travelersAdults;

  /// No description provided for @travelersAdultsSub.
  ///
  /// In en, this message translates to:
  /// **'Age 13+'**
  String get travelersAdultsSub;

  /// No description provided for @travelersChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get travelersChildren;

  /// No description provided for @travelersChildrenSub.
  ///
  /// In en, this message translates to:
  /// **'Age 0–12'**
  String get travelersChildrenSub;

  /// No description provided for @inviteCompanions.
  ///
  /// In en, this message translates to:
  /// **'Invite companions'**
  String get inviteCompanions;

  /// No description provided for @inviteCompanionsSub.
  ///
  /// In en, this message translates to:
  /// **'Optional · plan together'**
  String get inviteCompanionsSub;

  /// No description provided for @inviteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get inviteAdd;

  /// No description provided for @inviteAfterCreate.
  ///
  /// In en, this message translates to:
  /// **'They\'ll be invited once you create the trip.'**
  String get inviteAfterCreate;

  /// No description provided for @when.
  ///
  /// In en, this message translates to:
  /// **'When?'**
  String get when;

  /// No description provided for @datesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your dates, or stay flexible — you can change this later.'**
  String get datesSubtitle;

  /// No description provided for @presetThisWeekend.
  ///
  /// In en, this message translates to:
  /// **'This weekend'**
  String get presetThisWeekend;

  /// No description provided for @presetNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get presetNextWeek;

  /// No description provided for @presetInAMonth.
  ///
  /// In en, this message translates to:
  /// **'In a month'**
  String get presetInAMonth;

  /// No description provided for @presetFlexible.
  ///
  /// In en, this message translates to:
  /// **'I’m flexible'**
  String get presetFlexible;

  /// No description provided for @reviewTrip.
  ///
  /// In en, this message translates to:
  /// **'Review trip'**
  String get reviewTrip;

  /// No description provided for @selectDates.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDates;

  /// No description provided for @nightsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} night} other{{count} nights}}'**
  String nightsCount(int count);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} stop} other{{count} stops}}'**
  String stopsCount(int count);

  /// No description provided for @routeLabel.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get routeLabel;

  /// No description provided for @travelersLabel.
  ///
  /// In en, this message translates to:
  /// **'Travelers'**
  String get travelersLabel;

  /// No description provided for @datesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get datesLabel;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @adultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} adult} other{{count} adults}}'**
  String adultsCount(int count);

  /// No description provided for @childrenCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} child} other{{count} children}}'**
  String childrenCount(int count);

  /// No description provided for @buildPlanWithAi.
  ///
  /// In en, this message translates to:
  /// **'Build my plan with AI'**
  String get buildPlanWithAi;

  /// No description provided for @createEmptyTrip.
  ///
  /// In en, this message translates to:
  /// **'Build it myself'**
  String get createEmptyTrip;

  /// No description provided for @reviewFootnote.
  ///
  /// In en, this message translates to:
  /// **'No bookings here — add tickets & documents anytime.'**
  String get reviewFootnote;

  /// No description provided for @tripCreated.
  ///
  /// In en, this message translates to:
  /// **'Trip created'**
  String get tripCreated;

  /// No description provided for @tripNotFound.
  ///
  /// In en, this message translates to:
  /// **'Trip not found.'**
  String get tripNotFound;

  /// No description provided for @tripDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get tripDetailsTitle;

  /// No description provided for @tripOverviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tripOverviewTab;

  /// No description provided for @moduleItinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get moduleItinerary;

  /// No description provided for @moduleBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get moduleBudget;

  /// No description provided for @moduleDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get moduleDocuments;

  /// No description provided for @moduleChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get moduleChecklist;

  /// No description provided for @moduleChecklistShort.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get moduleChecklistShort;

  /// No description provided for @moduleMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get moduleMap;

  /// No description provided for @seeOnMap.
  ///
  /// In en, this message translates to:
  /// **'See on map'**
  String get seeOnMap;

  /// No description provided for @mapRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get mapRouteTitle;

  /// No description provided for @emptyMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to map yet'**
  String get emptyMapTitle;

  /// No description provided for @emptyMapBody.
  ///
  /// In en, this message translates to:
  /// **'Add places to your trip and they\'ll appear here on the map.'**
  String get emptyMapBody;

  /// No description provided for @emptyMapNoCoords.
  ///
  /// In en, this message translates to:
  /// **'The places on this trip don\'t have locations yet. Tap below to put them on the map.'**
  String get emptyMapNoCoords;

  /// No description provided for @mapFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mapFilterAll;

  /// No description provided for @mapLocating.
  ///
  /// In en, this message translates to:
  /// **'Finding places…'**
  String get mapLocating;

  /// No description provided for @mapFindPlaces.
  ///
  /// In en, this message translates to:
  /// **'Find places'**
  String get mapFindPlaces;

  /// No description provided for @mapMissingPlaces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} place has no location} other{{count} places have no location}}'**
  String mapMissingPlaces(int count);

  /// No description provided for @mapPlacesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} place} other{{count} places}}'**
  String mapPlacesCount(int count);

  /// No description provided for @mapDayDistance.
  ///
  /// In en, this message translates to:
  /// **'~{km} km'**
  String mapDayDistance(String km);

  /// No description provided for @mapDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this day is on the map yet'**
  String get mapDayEmpty;

  /// No description provided for @mapShowInPlan.
  ///
  /// In en, this message translates to:
  /// **'Show in the day plan'**
  String get mapShowInPlan;

  /// No description provided for @mapLocated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} place added to the map} other{{count} places added to the map}}'**
  String mapLocated(int count);

  /// No description provided for @mapNothingLocated.
  ///
  /// In en, this message translates to:
  /// **'No new places found'**
  String get mapNothingLocated;

  /// No description provided for @mapLocateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find the places. Check your connection.'**
  String get mapLocateFailed;

  /// No description provided for @aiHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Let Ventus plan {city}'**
  String aiHubTitle(String city);

  /// No description provided for @aiHubBody.
  ///
  /// In en, this message translates to:
  /// **'A day-by-day itinerary tuned to your dates, pace and the places you picked — ready in seconds.'**
  String get aiHubBody;

  /// No description provided for @aiHubGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate my plan'**
  String get aiHubGenerate;

  /// No description provided for @aiGenerating.
  ///
  /// In en, this message translates to:
  /// **'Crafting your plan…'**
  String get aiGenerating;

  /// No description provided for @aiPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Your plan is ready'**
  String get aiPlanReady;

  /// No description provided for @aiNeedsDestination.
  ///
  /// In en, this message translates to:
  /// **'Add a destination first.'**
  String get aiNeedsDestination;

  /// No description provided for @aiPlanUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI planning isn\'t available yet.'**
  String get aiPlanUnavailable;

  /// No description provided for @aiPlanNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the planner. Check your connection and try again.'**
  String get aiPlanNetworkError;

  /// No description provided for @aiPlanEmpty.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t build a plan. Try again in a moment.'**
  String get aiPlanEmpty;

  /// No description provided for @aiPlanFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate a plan. Try again.'**
  String get aiPlanFailed;

  /// No description provided for @aiNeedDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe your trip first.'**
  String get aiNeedDescription;

  /// No description provided for @aiReadingTrip.
  ///
  /// In en, this message translates to:
  /// **'Reading your trip…'**
  String get aiReadingTrip;

  /// No description provided for @aiParseEmpty.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find a place in that. Try naming a city.'**
  String get aiParseEmpty;

  /// No description provided for @aiParseFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read your trip. Try again.'**
  String get aiParseFailed;

  /// No description provided for @orStartManually.
  ///
  /// In en, this message translates to:
  /// **'Or start manually'**
  String get orStartManually;

  /// No description provided for @startBuildItinerary.
  ///
  /// In en, this message translates to:
  /// **'Build itinerary'**
  String get startBuildItinerary;

  /// No description provided for @startBuildItinerarySub.
  ///
  /// In en, this message translates to:
  /// **'Add days and activities yourself'**
  String get startBuildItinerarySub;

  /// No description provided for @startUploadDocs.
  ///
  /// In en, this message translates to:
  /// **'Upload tickets & documents'**
  String get startUploadDocs;

  /// No description provided for @startUploadDocsSub.
  ///
  /// In en, this message translates to:
  /// **'Flights, hotels, passports — all in one place'**
  String get startUploadDocsSub;

  /// No description provided for @startChecklist.
  ///
  /// In en, this message translates to:
  /// **'Create a checklist'**
  String get startChecklist;

  /// No description provided for @startChecklistSub.
  ///
  /// In en, this message translates to:
  /// **'Track what to pack and prepare'**
  String get startChecklistSub;

  /// No description provided for @deleteTripAction.
  ///
  /// In en, this message translates to:
  /// **'Delete trip'**
  String get deleteTripAction;

  /// No description provided for @deleteTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this trip?'**
  String get deleteTripTitle;

  /// No description provided for @deleteTripBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the trip and its details. This can’t be undone.'**
  String get deleteTripBody;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirm;

  /// No description provided for @tripDeleted.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted'**
  String get tripDeleted;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @emptyDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet'**
  String get emptyDayTitle;

  /// No description provided for @emptyDayBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first activity for this day.'**
  String get emptyDayBody;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get addActivity;

  /// No description provided for @newActivity.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get newActivity;

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get editActivity;

  /// No description provided for @activityTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get activityTitleLabel;

  /// No description provided for @activityTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bosphorus sunset walk'**
  String get activityTitleHint;

  /// No description provided for @activityTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a short title'**
  String get activityTitleRequired;

  /// No description provided for @activityPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get activityPlaceLabel;

  /// No description provided for @activityPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Karaköy'**
  String get activityPlaceHint;

  /// No description provided for @activityTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get activityTimeLabel;

  /// No description provided for @activityAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add a time'**
  String get activityAddTime;

  /// No description provided for @activityMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Add place or time'**
  String get activityMoreDetails;

  /// No description provided for @activityKindLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get activityKindLabel;

  /// No description provided for @activityDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get activityDayLabel;

  /// No description provided for @kindFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get kindFlight;

  /// No description provided for @kindStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get kindStay;

  /// No description provided for @kindFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get kindFood;

  /// No description provided for @kindSight.
  ///
  /// In en, this message translates to:
  /// **'Sight'**
  String get kindSight;

  /// No description provided for @kindTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get kindTransport;

  /// No description provided for @kindActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get kindActivity;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @setTime.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get setTime;

  /// No description provided for @deleteActivity.
  ///
  /// In en, this message translates to:
  /// **'Delete activity'**
  String get deleteActivity;

  /// No description provided for @deleteActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this activity?'**
  String get deleteActivityTitle;

  /// No description provided for @aiAssistTitle.
  ///
  /// In en, this message translates to:
  /// **'Some days are still open'**
  String get aiAssistTitle;

  /// No description provided for @aiAssistBody.
  ///
  /// In en, this message translates to:
  /// **'Let Ventus draft them for you'**
  String get aiAssistBody;

  /// No description provided for @planAction.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planAction;

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String checklistProgress(int done, int total);

  /// No description provided for @checklistItemHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Passport valid 6+ months'**
  String get checklistItemHint;

  /// No description provided for @renameChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Rename item'**
  String get renameChecklistItem;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @emptyChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to check off yet'**
  String get emptyChecklistTitle;

  /// No description provided for @emptyChecklistBody.
  ///
  /// In en, this message translates to:
  /// **'Add what you need to pack and prepare.'**
  String get emptyChecklistBody;

  /// No description provided for @checklistCatBeforeYouGo.
  ///
  /// In en, this message translates to:
  /// **'Before you go'**
  String get checklistCatBeforeYouGo;

  /// No description provided for @checklistCatPack.
  ///
  /// In en, this message translates to:
  /// **'Pack'**
  String get checklistCatPack;

  /// No description provided for @checklistCatOnArrival.
  ///
  /// In en, this message translates to:
  /// **'On arrival'**
  String get checklistCatOnArrival;

  /// No description provided for @defChkVisa.
  ///
  /// In en, this message translates to:
  /// **'Check / apply for visa'**
  String get defChkVisa;

  /// No description provided for @defChkInsurance.
  ///
  /// In en, this message translates to:
  /// **'Travel insurance'**
  String get defChkInsurance;

  /// No description provided for @defChkCheckin.
  ///
  /// In en, this message translates to:
  /// **'Online check-in'**
  String get defChkCheckin;

  /// No description provided for @defChkCash.
  ///
  /// In en, this message translates to:
  /// **'Exchange currency / cash'**
  String get defChkCash;

  /// No description provided for @defChkPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get defChkPassport;

  /// No description provided for @defChkTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets (flight / train)'**
  String get defChkTickets;

  /// No description provided for @defChkId.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get defChkId;

  /// No description provided for @defChkCharger.
  ///
  /// In en, this message translates to:
  /// **'Charger / adapter'**
  String get defChkCharger;

  /// No description provided for @defChkSim.
  ///
  /// In en, this message translates to:
  /// **'Local SIM / eSIM'**
  String get defChkSim;

  /// No description provided for @defChkHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel check-in'**
  String get defChkHotel;

  /// No description provided for @defChkTransport.
  ///
  /// In en, this message translates to:
  /// **'Local transport'**
  String get defChkTransport;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @addToChecklist.
  ///
  /// In en, this message translates to:
  /// **'Add to checklist'**
  String get addToChecklist;

  /// No description provided for @editChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editChecklistItem;

  /// No description provided for @deleteChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteChecklistItem;

  /// No description provided for @checklistCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get checklistCategoryLabel;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder'**
  String get setReminder;

  /// No description provided for @dueBy.
  ///
  /// In en, this message translates to:
  /// **'Do by {date}'**
  String dueBy(String date);

  /// No description provided for @documentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} file} other{{count} files}}'**
  String documentsCount(int count);

  /// No description provided for @docPhotoName.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get docPhotoName;

  /// No description provided for @docFileName.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get docFileName;

  /// No description provided for @docGroupTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get docGroupTickets;

  /// No description provided for @docGroupStays.
  ///
  /// In en, this message translates to:
  /// **'Stays'**
  String get docGroupStays;

  /// No description provided for @docGroupIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get docGroupIdentity;

  /// No description provided for @docGroupOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docGroupOther;

  /// No description provided for @docGroupTripWide.
  ///
  /// In en, this message translates to:
  /// **'Trip-wide'**
  String get docGroupTripWide;

  /// No description provided for @docTypeTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get docTypeTicket;

  /// No description provided for @docTypeStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get docTypeStay;

  /// No description provided for @docTypeId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get docTypeId;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// No description provided for @addDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a document'**
  String get addDocumentTitle;

  /// No description provided for @addDocumentBody.
  ///
  /// In en, this message translates to:
  /// **'Tickets, vouchers & IDs stay private to this trip.'**
  String get addDocumentBody;

  /// No description provided for @sourceFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get sourceFiles;

  /// No description provided for @sourceFilesSub.
  ///
  /// In en, this message translates to:
  /// **'PDF, Pages, anything'**
  String get sourceFilesSub;

  /// No description provided for @sourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get sourceCamera;

  /// No description provided for @sourceCameraSub.
  ///
  /// In en, this message translates to:
  /// **'Scan a paper ticket or ID'**
  String get sourceCameraSub;

  /// No description provided for @sourcePhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get sourcePhotos;

  /// No description provided for @sourcePhotosSub.
  ///
  /// In en, this message translates to:
  /// **'Pick from your library'**
  String get sourcePhotosSub;

  /// No description provided for @saveDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get saveDocumentTitle;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get documentTypeLabel;

  /// No description provided for @linkToDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Link to day (optional)'**
  String get linkToDayLabel;

  /// No description provided for @saveToDocuments.
  ///
  /// In en, this message translates to:
  /// **'Save to Documents'**
  String get saveToDocuments;

  /// No description provided for @docDayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · {date}'**
  String docDayWithDate(int day, String date);

  /// No description provided for @docDayShort.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String docDayShort(int day);

  /// No description provided for @editDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get editDocumentTitle;

  /// No description provided for @documentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get documentNameLabel;

  /// No description provided for @documentNameHint.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get documentNameHint;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get deleteDocumentTitle;

  /// No description provided for @deleteDocumentBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes the file. This can’t be undone.'**
  String get deleteDocumentBody;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeleted;

  /// No description provided for @docActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get docActionShare;

  /// No description provided for @docActionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get docActionSave;

  /// No description provided for @docActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get docActionEdit;

  /// No description provided for @docActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get docActionDelete;

  /// No description provided for @documentLinkedTo.
  ///
  /// In en, this message translates to:
  /// **'Linked to {day}'**
  String documentLinkedTo(String day);

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openFile;

  /// No description provided for @previewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview isn’t available here.'**
  String get previewUnavailable;

  /// No description provided for @connectToView.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to view this file.'**
  String get connectToView;

  /// No description provided for @emptyDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get emptyDocumentsTitle;

  /// No description provided for @emptyDocumentsBody.
  ///
  /// In en, this message translates to:
  /// **'Upload your tickets, vouchers and IDs to keep them handy.'**
  String get emptyDocumentsBody;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t upload — try again.'**
  String get uploadFailed;

  /// No description provided for @budgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budgetRemaining;

  /// No description provided for @budgetOfTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String budgetOfTotal(String total);

  /// No description provided for @budgetSpentUsed.
  ///
  /// In en, this message translates to:
  /// **'{spent} spent · {percent}% used'**
  String budgetSpentUsed(String spent, int percent);

  /// No description provided for @budgetLeftPct.
  ///
  /// In en, this message translates to:
  /// **'{percent}% left'**
  String budgetLeftPct(int percent);

  /// No description provided for @budgetByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get budgetByCategory;

  /// No description provided for @budgetExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get budgetExpenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @budgetTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total trip budget'**
  String get budgetTotalLabel;

  /// No description provided for @budgetAllocateByCategory.
  ///
  /// In en, this message translates to:
  /// **'Allocate by category'**
  String get budgetAllocateByCategory;

  /// No description provided for @budgetAllocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get budgetAllocated;

  /// No description provided for @budgetSave.
  ///
  /// In en, this message translates to:
  /// **'Save budget'**
  String get budgetSave;

  /// No description provided for @budgetCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get budgetCurrency;

  /// No description provided for @expCatStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get expCatStay;

  /// No description provided for @expCatFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expCatFood;

  /// No description provided for @expCatSight.
  ///
  /// In en, this message translates to:
  /// **'Sights'**
  String get expCatSight;

  /// No description provided for @expCatTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expCatTransport;

  /// No description provided for @expCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expCatOther;

  /// No description provided for @expenseNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note…'**
  String get expenseNoteHint;

  /// No description provided for @addAmountTo.
  ///
  /// In en, this message translates to:
  /// **'Add {amount} to {category}'**
  String addAmountTo(String amount, String category);

  /// No description provided for @budgetUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get budgetUnassigned;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get deleteExpenseTitle;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted'**
  String get expenseDeleted;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get amountRequired;

  /// No description provided for @emptyExpensesBody.
  ///
  /// In en, this message translates to:
  /// **'No expenses logged yet.'**
  String get emptyExpensesBody;

  /// No description provided for @setBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your trip budget'**
  String get setBudgetTitle;

  /// No description provided for @setBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'Add a total and Ventus tracks what’s left as you spend.'**
  String get setBudgetBody;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a budget'**
  String get setBudget;

  /// No description provided for @privacySectionAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get privacySectionAppLock;

  /// No description provided for @privacySectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get privacySectionAccount;

  /// No description provided for @privacySectionDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get privacySectionDanger;

  /// No description provided for @privacyChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get privacyChangePin;

  /// No description provided for @privacyChangePinSub.
  ///
  /// In en, this message translates to:
  /// **'Quick-unlock PIN for this device'**
  String get privacyChangePinSub;

  /// No description provided for @privacyChangePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get privacyChangePasswordSub;

  /// No description provided for @privacyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get privacyDeleteAccount;

  /// No description provided for @privacyDeleteAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account and data'**
  String get privacyDeleteAccountSub;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and all your trips. This can\'t be undone.'**
  String get deleteAccountBody;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get accountDeleted;

  /// No description provided for @changePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// No description provided for @changePinVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get changePinVerifyTitle;

  /// No description provided for @changePinVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you before changing your PIN.'**
  String get changePinVerifyBody;

  /// No description provided for @changePinNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new PIN'**
  String get changePinNewTitle;

  /// No description provided for @changePinNewBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a 4-digit PIN you\'ll remember.'**
  String get changePinNewBody;

  /// No description provided for @changePinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new PIN'**
  String get changePinConfirmTitle;

  /// No description provided for @changePinConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Type your new PIN again to confirm.'**
  String get changePinConfirmBody;

  /// No description provided for @changePinWrong.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get changePinWrong;

  /// No description provided for @changePinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs didn\'t match. Start again.'**
  String get changePinMismatch;

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN updated'**
  String get pinChanged;

  /// No description provided for @pinTooWeak.
  ///
  /// In en, this message translates to:
  /// **'That PIN is too easy to guess. Try a different one.'**
  String get pinTooWeak;

  /// No description provided for @pinLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in'**
  String get pinLockedOut;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get changePasswordAction;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordsDontMatch;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect.'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordChanged;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 8 characters.'**
  String get authWeakPassword;

  /// No description provided for @authSamePassword.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from the current one.'**
  String get authSamePassword;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Ventus Pro'**
  String get proTitle;

  /// No description provided for @proTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan without limits.'**
  String get proTagline;

  /// No description provided for @proBillingYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get proBillingYearly;

  /// No description provided for @proBillingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get proBillingMonthly;

  /// No description provided for @proSave.
  ///
  /// In en, this message translates to:
  /// **'Save 30%'**
  String get proSave;

  /// No description provided for @proPerYear.
  ///
  /// In en, this message translates to:
  /// **'/yr'**
  String get proPerYear;

  /// No description provided for @proPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get proPerMonth;

  /// No description provided for @proYearlyEquiv.
  ///
  /// In en, this message translates to:
  /// **'≈ \$3.50/mo'**
  String get proYearlyEquiv;

  /// No description provided for @proBilledMonthly.
  ///
  /// In en, this message translates to:
  /// **'billed monthly'**
  String get proBilledMonthly;

  /// No description provided for @proColFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get proColFeature;

  /// No description provided for @proColFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get proColFree;

  /// No description provided for @proColPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proColPro;

  /// No description provided for @proRowTrips.
  ///
  /// In en, this message translates to:
  /// **'Active trips'**
  String get proRowTrips;

  /// No description provided for @proRowAiPlans.
  ///
  /// In en, this message translates to:
  /// **'AI day plans'**
  String get proRowAiPlans;

  /// No description provided for @proRowOfflineMaps.
  ///
  /// In en, this message translates to:
  /// **'Offline maps'**
  String get proRowOfflineMaps;

  /// No description provided for @proRowCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get proRowCollaborators;

  /// No description provided for @proRowVault.
  ///
  /// In en, this message translates to:
  /// **'Document vault'**
  String get proRowVault;

  /// No description provided for @proFreeAiPlansPerMonth.
  ///
  /// In en, this message translates to:
  /// **'5/mo'**
  String get proFreeAiPlansPerMonth;

  /// No description provided for @proCtaTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 7-day free trial'**
  String get proCtaTrial;

  /// No description provided for @proComingSoon.
  ///
  /// In en, this message translates to:
  /// **'We\'re still building Ventus Pro. We\'ll let you know when it\'s ready.'**
  String get proComingSoon;

  /// No description provided for @proThenYearly.
  ///
  /// In en, this message translates to:
  /// **'Then \$41.99/yr · cancel anytime'**
  String get proThenYearly;

  /// No description provided for @proThenMonthly.
  ///
  /// In en, this message translates to:
  /// **'Then \$4.99/mo · cancel anytime'**
  String get proThenMonthly;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notifToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifToday;

  /// No description provided for @notifEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifEarlier;

  /// No description provided for @notifMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkRead;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Trip activity and AI updates will show up here.'**
  String get notifEmptyBody;

  /// No description provided for @notifNewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String notifNewCount(int count);

  /// No description provided for @notifCollabInvitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Invited {email}'**
  String notifCollabInvitedTitle(String email);

  /// No description provided for @notifCollabInvitedBody.
  ///
  /// In en, this message translates to:
  /// **'Trip: {trip}. Invite sent.'**
  String notifCollabInvitedBody(String trip);

  /// No description provided for @notifCollabInvitedBodyShort.
  ///
  /// In en, this message translates to:
  /// **'Invite sent.'**
  String get notifCollabInvitedBodyShort;

  /// No description provided for @notifAiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI day plan is ready'**
  String get notifAiReadyTitle;

  /// No description provided for @notifAiReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Trip: {trip}'**
  String notifAiReadyBody(String trip);

  /// No description provided for @notifAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get notifAccepted;

  /// No description provided for @notifAcceptInvite.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get notifAcceptInvite;

  /// No description provided for @notifGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get notifGenericTitle;

  /// No description provided for @notifWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ventus 👋'**
  String get notifWelcomeTitle;

  /// No description provided for @notifWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready. Plan your first trip and let Ventus handle the details.'**
  String get notifWelcomeBody;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @changeCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Change cover photo'**
  String get changeCoverPhoto;

  /// No description provided for @coverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get coverUpdated;

  /// No description provided for @coverRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove cover photo'**
  String get coverRemove;

  /// No description provided for @notifDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get notifDeleteAll;

  /// No description provided for @notifConfirmMarkAllReadTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read?'**
  String get notifConfirmMarkAllReadTitle;

  /// No description provided for @notifConfirmMarkAllReadBody.
  ///
  /// In en, this message translates to:
  /// **'All notifications will be marked as read.'**
  String get notifConfirmMarkAllReadBody;

  /// No description provided for @notifConfirmDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all notifications?'**
  String get notifConfirmDeleteAllTitle;

  /// No description provided for @notifConfirmDeleteAllBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes all your notifications. This can’t be undone.'**
  String get notifConfirmDeleteAllBody;

  /// No description provided for @notifMarkReadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get notifMarkReadConfirm;

  /// No description provided for @notifDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get notifDeleteAllConfirm;

  /// No description provided for @tripStatDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'days to go'**
  String get tripStatDaysLeft;

  /// No description provided for @tripStatPlanned.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get tripStatPlanned;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greetingMorning(String name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String greetingEvening(String name);

  /// No description provided for @nextStepEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get nextStepEyebrow;

  /// No description provided for @nextStepPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your day-by-day plan'**
  String get nextStepPlanTitle;

  /// No description provided for @nextStepPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Add the first activity — the rest comes easily.'**
  String get nextStepPlanBody;

  /// No description provided for @nextStepChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a checklist'**
  String get nextStepChecklistTitle;

  /// No description provided for @nextStepChecklistBody.
  ///
  /// In en, this message translates to:
  /// **'What shouldn\'t you forget before leaving?'**
  String get nextStepChecklistBody;

  /// No description provided for @nextStepBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a budget'**
  String get nextStepBudgetTitle;

  /// No description provided for @nextStepBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'Track spending as it happens.'**
  String get nextStepBudgetBody;

  /// No description provided for @nextStepDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your documents'**
  String get nextStepDocsTitle;

  /// No description provided for @nextStepDocsBody.
  ///
  /// In en, this message translates to:
  /// **'Keep tickets and bookings in one place.'**
  String get nextStepDocsBody;

  /// No description provided for @planCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan complete'**
  String get planCompleteTitle;

  /// No description provided for @planCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Every day is planned. Have a great trip!'**
  String get planCompleteBody;

  /// No description provided for @tripDeleteOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can delete this trip.'**
  String get tripDeleteOwnerOnly;

  /// No description provided for @collabTripOwner.
  ///
  /// In en, this message translates to:
  /// **'Trip owner'**
  String get collabTripOwner;

  /// No description provided for @overviewReadiness.
  ///
  /// In en, this message translates to:
  /// **'Getting ready'**
  String get overviewReadiness;

  /// No description provided for @overviewNextUp.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get overviewNextUp;

  /// No description provided for @readinessDaysPlanned.
  ///
  /// In en, this message translates to:
  /// **'{planned}/{total} days planned'**
  String readinessDaysPlanned(int planned, int total);

  /// No description provided for @readinessActivities.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} activity} other{{count} activities}}'**
  String readinessActivities(int count);

  /// No description provided for @readinessBudgetNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get readinessBudgetNotSet;

  /// No description provided for @readinessNoDocs.
  ///
  /// In en, this message translates to:
  /// **'Nothing uploaded'**
  String get readinessNoDocs;

  /// No description provided for @readinessEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get readinessEmpty;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in maps'**
  String get openInMaps;

  /// No description provided for @taxiSection.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get taxiSection;

  /// No description provided for @datesPickStartOnly.
  ///
  /// In en, this message translates to:
  /// **'You said {count, plural, one{{count} night} other{{count} nights}} — just pick the day you leave.'**
  String datesPickStartOnly(int count);

  /// No description provided for @checklistAllDone.
  ///
  /// In en, this message translates to:
  /// **'All set. Safe travels!'**
  String get checklistAllDone;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSectionSupport;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuHelp;

  /// No description provided for @menuContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get menuContact;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan, keep and follow your trip in one place.'**
  String get aboutTagline;

  /// No description provided for @aboutLegalSection.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get aboutLegalSection;

  /// No description provided for @contactMailSubject.
  ///
  /// In en, this message translates to:
  /// **'Ventus support'**
  String get contactMailSubject;

  /// No description provided for @contactMailBody.
  ///
  /// In en, this message translates to:
  /// **'Hi, my question/problem:\n\n\n— App: {version}\n— Device: {device}'**
  String contactMailBody(String version, String device);

  /// No description provided for @contactMailFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your mail app. Write to us at support@ventus.app'**
  String get contactMailFailed;

  /// No description provided for @helpQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a trip?'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button in the middle of the home screen, then pick the place and dates. You can also choose “Plan with AI” and describe your trip in a sentence — it finds the place, dates and who\'s going.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In en, this message translates to:
  /// **'How does the AI plan work?'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In en, this message translates to:
  /// **'On your trip\'s page tap “Generate my plan” and Ventus suggests a day-by-day plan. It\'s guidance only — always double-check times, prices and bookings yourself.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In en, this message translates to:
  /// **'Does it work offline?'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In en, this message translates to:
  /// **'Your trips, day plan, checklist and budget are stored on your phone and open without internet. They sync when you\'re back online. AI, maps, weather and currency need internet.'**
  String get helpA3;

  /// No description provided for @helpQ4.
  ///
  /// In en, this message translates to:
  /// **'Where are my documents stored?'**
  String get helpQ4;

  /// No description provided for @helpA4.
  ///
  /// In en, this message translates to:
  /// **'Your tickets and other documents are kept securely in private storage that only you can open. Nobody sees them unless you share them.'**
  String get helpA4;

  /// No description provided for @helpQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I open a place on the map?'**
  String get helpQ5;

  /// No description provided for @helpA5.
  ///
  /// In en, this message translates to:
  /// **'In the day plan tap the compass icon on the right of an activity card. The maps and taxi apps on your phone appear — pick one.'**
  String get helpA5;

  /// No description provided for @helpQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get helpQ6;

  /// No description provided for @helpA6.
  ///
  /// In en, this message translates to:
  /// **'Profile → Privacy & security → Delete account. This permanently deletes your account and all your trips and can\'t be undone.'**
  String get helpA6;
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
      <String>['az', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
