// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ventus';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get welcomeToVentus => 'Welcome to Ventus';

  @override
  String greeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get yourTrips => 'Your trips';

  @override
  String get seeAll => 'See all';

  @override
  String get allTrips => 'All trips';

  @override
  String get tripsUpcoming => 'Upcoming';

  @override
  String get tripsPast => 'Past';

  @override
  String get allTripsEmptyBody =>
      'Your planned and past trips will show up here.';

  @override
  String get sharedViaVentus => 'Planned with Ventus ✈️';

  @override
  String get discover => 'Discover';

  @override
  String get sponsored => 'Sponsored';

  @override
  String get planWithAi => 'Plan with AI';

  @override
  String get planWithAiSubtitle => 'Tell me where you’re going next';

  @override
  String get whereToFirst => 'Where to first?';

  @override
  String get emptyHomeBody =>
      'Write the route by hand, or describe it in a sentence and let AI build it.';

  @override
  String get planNewTrip => 'New trip';

  @override
  String tripDaysToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days to go',
      one: '$count day to go',
    );
    return '$_temp0';
  }

  @override
  String get tripToday => 'Today';

  @override
  String get tripInProgress => 'In progress';

  @override
  String percentPlanned(int percent) {
    return '$percent% planned';
  }

  @override
  String get tripStartPlanning => 'Start planning';

  @override
  String get couldNotLoadTrips => 'Could not load your trips.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutBody => 'You can sign back in any time.';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get setPasswordTitle => 'Set a password';

  @override
  String get setPasswordAction => 'Set password';

  @override
  String get setPasswordNote =>
      'You signed in with Google, so your account has no password yet. Set one and you\'ll be able to sign in with your email too.';

  @override
  String get passwordSet => 'Password set.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get notificationsTitleShort => 'Notifications';

  @override
  String get offlineBanner =>
      'You\'re offline — changes sync when you\'re back.';

  @override
  String get edit => 'Edit';

  @override
  String get clear => 'Clear';

  @override
  String get savedAdd => 'Save';

  @override
  String get savedRemove => 'Remove from saved';

  @override
  String get signOut => 'Sign out';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get somethingWentWrong => 'Something went wrong. Try again.';

  @override
  String get navHome => 'Home';

  @override
  String get navTrips => 'Trips';

  @override
  String get navSaved => 'Saved';

  @override
  String get navTools => 'Tools';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTripSoon => 'Your trip is coming up';

  @override
  String get homeTripToday => 'You leave today';

  @override
  String get homeTripOngoing => 'Trip in progress';

  @override
  String get homeWhereTo => 'Where to?';

  @override
  String get homeSearchHint => 'Where to?';

  @override
  String get createSheetTitle => 'New trip';

  @override
  String get createSheetSubtitle => 'How do you want to start?';

  @override
  String get createAiBadge => 'FAST';

  @override
  String get createAiBody =>
      'Write \"4 days in Rome in October, museums and food\" — get an instant plan.';

  @override
  String get createManualBody =>
      'Pick the destination, dates and travel companions yourself.';

  @override
  String get sheetClose => 'Close';

  @override
  String get tripPickerTitle => 'My trips';

  @override
  String get addNewTripShort => 'New';

  @override
  String get emptyHomeTitle => 'Plan your next trip';

  @override
  String get toolsSubtitle => 'Handy on the road · works offline';

  @override
  String get toolCurrency => 'Currency converter';

  @override
  String get toolWeather => 'Weather';

  @override
  String get toolWorldClock => 'Timezone';

  @override
  String get toolTip => 'Tip calculator';

  @override
  String get toolsSectionWeather => 'Weather & time';

  @override
  String get toolsSectionMoney => 'Money';

  @override
  String get toolsOffline => 'Couldn\'t load. Check your connection.';

  @override
  String get clockHome => 'Home';

  @override
  String clockBehindHome(String hours) {
    return '$hours h behind home';
  }

  @override
  String clockAheadOfHome(String hours) {
    return '$hours h ahead of home';
  }

  @override
  String get clockSameAsHome => 'Same time as home';

  @override
  String get clockSameShort => 'Same';

  @override
  String get clockYesterday => 'Yesterday';

  @override
  String get clockHourShort => 'h';

  @override
  String get clockCityRemoved => 'City removed';

  @override
  String currencyUpdated(Object date) {
    return 'Updated $date';
  }

  @override
  String get curUSD => 'US dollar';

  @override
  String get curEUR => 'Euro';

  @override
  String get curGBP => 'British pound';

  @override
  String get curTRY => 'Turkish lira';

  @override
  String get curAZN => 'Azerbaijani manat';

  @override
  String get curAED => 'UAE dirham';

  @override
  String get curGEL => 'Georgian lari';

  @override
  String toolsActiveTripBanner(Object trip) {
    return 'Active trip: $trip';
  }

  @override
  String toolsCurrencyHint(
    Object fromGlyph,
    Object rate,
    Object toGlyph,
    Object when,
  ) {
    return '1 $fromGlyph = $rate $toGlyph · $when';
  }

  @override
  String get toolsRateToday => 'today';

  @override
  String toolsTimezoneHint(Object hours, Object away) {
    return '$away · ${hours}h difference';
  }

  @override
  String get toolsTimezoneEmptyHint => 'Add a city to compare times';

  @override
  String toolsWeatherHint(Object temp, Object city) {
    return '$temp° · $city';
  }

  @override
  String get currencyAmountLabel => 'Amount to convert';

  @override
  String get currencyConvertedLabel => 'Converted amount';

  @override
  String currencyRateLine(Object from, Object rate, Object to) {
    return '1 $from = $rate $to';
  }

  @override
  String currencyRateSourceMarket(Object date) {
    return 'Market rate · $date';
  }

  @override
  String currencyRateSource(Object date) {
    return 'Central Bank of Azerbaijan official rate · $date';
  }

  @override
  String get quickAmountsLabel => 'Quick amounts';

  @override
  String get addToBudgetAsExpense => 'Add to budget as an expense';

  @override
  String get expenseAdded => 'Added to your trip budget.';

  @override
  String get currencyPickerTitle => 'Choose a currency';

  @override
  String get currencySearchHint => 'Search currency or country';

  @override
  String get currencyAllLabel => 'All currencies';

  @override
  String get currencyHomeCurrency => 'Home currency';

  @override
  String get currencyTripCurrency => 'Active trip currency';

  @override
  String get timezoneTripTag => 'active trip';

  @override
  String get tipOtherPercent => 'Other';

  @override
  String get tipCustomPercentHint => 'Percent';

  @override
  String get weatherToday => 'Today';

  @override
  String get weatherNextDays => 'Next 5 days';

  @override
  String get weatherNow => 'Now';

  @override
  String get weatherTomorrow => 'Tomorrow';

  @override
  String get weatherFeelsLike => 'Feels like';

  @override
  String get weatherWind => 'Wind';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherRainChance => 'Chance of rain';

  @override
  String get weatherSunrise => 'Sunrise';

  @override
  String get weatherSunset => 'Sunset';

  @override
  String weatherWindKmh(String value) {
    return '$value km/h';
  }

  @override
  String weatherWindMph(String value) {
    return '$value mph';
  }

  @override
  String get wxClear => 'Clear';

  @override
  String get wxPartly => 'Partly cloudy';

  @override
  String get wxCloudy => 'Cloudy';

  @override
  String get wxFog => 'Foggy';

  @override
  String get wxDrizzle => 'Drizzle';

  @override
  String get wxRain => 'Rain';

  @override
  String get wxSnow => 'Snow';

  @override
  String get wxStorm => 'Thunderstorm';

  @override
  String get tipSubtitle => 'Quick gratuity · offline';

  @override
  String get tipTotal => 'Total';

  @override
  String get tipAmount => 'Tip';

  @override
  String get tipPerPerson => 'Per person';

  @override
  String get tipBillLabel => 'Bill amount';

  @override
  String get tipPercentLabel => 'Tip';

  @override
  String get tipSplitLabel => 'Split between';

  @override
  String tipExampleBill(String glyph) {
    return 'Bill ${glyph}0 · 0%';
  }

  @override
  String tipPeopleCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0';
  }

  @override
  String get searchCity => 'Search a city';

  @override
  String get searchCityHint => 'Type a city name…';

  @override
  String get noCitiesFound => 'No cities found.';

  @override
  String get exploreTitle => 'Discover';

  @override
  String get exploreSubtitle => 'Places to inspire you';

  @override
  String get exploreAsk => 'Ask Ventus';

  @override
  String get exploreEmpty => 'Nothing to explore yet.';

  @override
  String get exploreSearchHint => 'Search a city or country';

  @override
  String exploreNoMatches(Object query) {
    return 'Nothing matched \"$query\".';
  }

  @override
  String get exploreCuratedSection => 'In Ventus';

  @override
  String get exploreOtherPlacesSection => 'Other places';

  @override
  String get exploreSearching => 'Searching…';

  @override
  String get exploreStartTripHere => 'Plan a trip here';

  @override
  String get savedTitleShort => 'Saved';

  @override
  String get planTripHere => 'Plan a trip here';

  @override
  String get factCurrency => 'Currency';

  @override
  String get factLanguage => 'Language';

  @override
  String get factBestTime => 'Best time';

  @override
  String get factTimezone => 'Timezone';

  @override
  String get destGoodToKnow => 'Good to know';

  @override
  String get destAskPlan => 'Plan with Ventus';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Show less';

  @override
  String get savedEmptyTitle => 'No saved places yet';

  @override
  String get savedEmptyBody => 'Tap the heart on places you like in Discover.';

  @override
  String get welcomeTagline => 'YOUR AI TRAVEL COMPANION';

  @override
  String get welcomeHeadline => 'Every journey,\nbeautifully planned.';

  @override
  String get welcomeSubtitle =>
      'Itinerary, budget, documents and tickets — together in one calm place.';

  @override
  String get getStarted => 'Get started';

  @override
  String get haveAccount => 'I already have an account';

  @override
  String get signInSubtitle => 'Sign in to continue your journey.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgot => 'Forgot?';

  @override
  String get signInAction => 'Sign in';

  @override
  String get orDivider => 'or';

  @override
  String get newToVentus => 'New to Ventus?';

  @override
  String get createAccountAction => 'Create account';

  @override
  String providerComingSoon(String provider) {
    return '$provider sign-in is coming soon.';
  }

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountSubtitle => 'Join Ventus and plan your next trip.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Your name';

  @override
  String get passwordHintMin => 'At least 8 characters';

  @override
  String get agreeTerms => 'I agree to the Terms & Privacy Policy';

  @override
  String get agreeTermsRich => 'I agree to the [terms] and [privacy].';

  @override
  String get termsLinkLabel => 'Terms of Service';

  @override
  String get privacyLinkLabel => 'Privacy Policy';

  @override
  String get acceptTermsError =>
      'Accept the Terms & Privacy Policy to continue.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get forgotTitle => 'Forgot your password?';

  @override
  String get forgotBody =>
      'Enter the email linked to your account and we’ll send you a reset code.';

  @override
  String get sendResetLink => 'Send code';

  @override
  String get resetSent => 'Reset link sent. Check your inbox.';

  @override
  String get rememberedIt => 'Remembered it?';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get verifyEmailTitle => 'Confirm your email';

  @override
  String verifyEmailBody(String email) {
    return 'We sent a confirmation link to $email. Tap it to verify your account, then come back to sign in.';
  }

  @override
  String get verifyEmailSpamNote =>
      'Didn’t get it? Check your spam folder or resend.';

  @override
  String get verifyEmailResend => 'Resend email';

  @override
  String get verifyEmailResent => 'Confirmation email sent. Check your inbox.';

  @override
  String get verifyEmailSignIn => 'Go to sign in';

  @override
  String get resetCodeTitle => 'Set a new password';

  @override
  String resetCodeBody(String email) {
    return 'We emailed a 6-digit code to $email. Enter it below and choose a new password.';
  }

  @override
  String get resetCodeLabel => 'Reset code';

  @override
  String get resetCodeHint => '123456';

  @override
  String get resetSubmit => 'Reset password';

  @override
  String get resetSuccess => 'Password updated. You’re all set.';

  @override
  String get resetResend => 'Resend code';

  @override
  String get resetResent => 'A new code is on its way.';

  @override
  String get authInvalidOtp => 'That code is incorrect or has expired.';

  @override
  String get authRateLimited =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get legalUpdated => 'Last updated: June 2026';

  @override
  String get legalContact =>
      'Questions about these terms or your data? Contact us at support@ventus.app.';

  @override
  String get legalTermsTitle => 'Terms of Service';

  @override
  String get legalTermsIntro =>
      'Welcome to Ventus. By creating an account and using the app, you agree to these Terms. If you do not agree, please do not use Ventus.';

  @override
  String get legalTermsS1Title => 'Using Ventus';

  @override
  String get legalTermsS1Body =>
      'Ventus helps you plan and organize trips. Use it only for lawful, personal purposes, and do not misuse, copy, or try to disrupt the service. AI-generated plans and suggestions are for guidance only — always verify times, prices, visas, and bookings yourself.';

  @override
  String get legalTermsS2Title => 'Your account';

  @override
  String get legalTermsS2Body =>
      'You are responsible for keeping your email, password, and PIN secure, and for all activity on your account. Let us know right away if you notice any unauthorized use.';

  @override
  String get legalTermsS3Title => 'Your content';

  @override
  String get legalTermsS3Body =>
      'Trips, notes, files, and other content you add remain yours. You grant Ventus permission to store, sync, and process this content solely to provide the app\'s features to you.';

  @override
  String get legalTermsS4Title => 'Service & liability';

  @override
  String get legalTermsS4Body =>
      'Ventus is provided “as is”, without warranties. We may add, change, or remove features, and we are not liable for losses arising from third-party data (maps, weather, AI) or interruptions to the service.';

  @override
  String get legalPrivacyTitle => 'Privacy Policy';

  @override
  String get legalPrivacyIntro =>
      'This policy explains what information Ventus collects, how we use it, and the choices you have.';

  @override
  String get legalPrivacyS1Title => 'What we collect';

  @override
  String get legalPrivacyS1Body =>
      'Account details (your name and email) and the trip data you create — destinations, itineraries, checklists, budgets, documents, and saved places. Your PIN is stored only on your device and is never sent to our servers.';

  @override
  String get legalPrivacyS2Title => 'How we use it';

  @override
  String get legalPrivacyS2Body =>
      'To run your account, sync your trips across devices, and power features like AI planning. When you generate a plan, the relevant trip details are sent to our AI provider (Google Gemini) to create it. We never sell your data.';

  @override
  String get legalPrivacyS3Title => 'Storage & security';

  @override
  String get legalPrivacyS3Body =>
      'Your data is stored securely with our backend provider (Supabase) and encrypted in transit. Map, weather, and currency features query third-party services with only the data needed to answer your request.';

  @override
  String get legalPrivacyS4Title => 'Your rights';

  @override
  String get legalPrivacyS4Body =>
      'You can view and edit your profile, change your password or PIN, and request deletion of your account and data at any time from Settings.';

  @override
  String get createPinTitle => 'Create a PIN';

  @override
  String get createPinBody =>
      'Set a 4-digit code for quick, secure access next time.';

  @override
  String get enterPinToUnlock => 'Enter your PIN to unlock';

  @override
  String get usePasswordInstead => 'Use password instead';

  @override
  String get incorrectPin => 'Incorrect PIN.';

  @override
  String get errEmailRequired => 'Enter your email';

  @override
  String get errEmailInvalid => 'Enter a valid email';

  @override
  String get errPasswordRequired => 'Enter your password';

  @override
  String get errPasswordTooShort => 'At least 8 characters';

  @override
  String get errNameRequired => 'Enter your name';

  @override
  String get authInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authEmailExists =>
      'An account with this email already exists. Sign in instead.';

  @override
  String get authEmailNotConfirmed =>
      'Check your inbox to confirm your email, then sign in.';

  @override
  String get profileEdit => 'Edit';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get avatarTakePhoto => 'Take photo';

  @override
  String get avatarChooseLibrary => 'Choose from library';

  @override
  String get avatarRemove => 'Remove photo';

  @override
  String get emailReadonlyNote => 'Email can\'t be changed here.';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get profileSaved => 'Profile updated';

  @override
  String get profileSaveFailed => 'Couldn\'t save your profile. Try again.';

  @override
  String get profileEditUnavailable => 'Sign in to edit your profile.';

  @override
  String get measurementSystem => 'Measurement';

  @override
  String get unitMetric => 'Metric';

  @override
  String get unitMetricDesc => 'Kilometres, °C';

  @override
  String get unitImperial => 'Imperial';

  @override
  String get unitImperialDesc => 'Miles, °F';

  @override
  String get collaboratorsTitle => 'Collaborators';

  @override
  String get collaboratorsManageSub => 'Invite people to plan together';

  @override
  String collabPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get collabPending => 'Pending';

  @override
  String get collabRemoved => 'Collaborator removed';

  @override
  String get collabAnyoneWithLink => 'Anyone with the link';

  @override
  String get collabCopy => 'Copy';

  @override
  String get collabLinkCopied => 'Invite link copied';

  @override
  String get collabYou => 'You';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleViewer => 'Viewer';

  @override
  String get roleEditorDesc => 'Add & edit itinerary, budget, docs';

  @override
  String get roleViewerDesc => 'See the trip, can’t make changes';

  @override
  String get collabInviteSent => 'Invite sent · pending';

  @override
  String get removeCollaborator => 'Remove';

  @override
  String get inviteTitle => 'Invite to trip';

  @override
  String get inviteRoleLabel => 'Role';

  @override
  String get inviteEmailInvalid => 'Enter a valid email';

  @override
  String get sendInvite => 'Send invite';

  @override
  String get collabInviteSentToast => 'Invite sent';

  @override
  String get collabPickTrip => 'Choose a trip';

  @override
  String get collabNoTrips => 'Create a trip first to invite people.';

  @override
  String get statCountries => 'Countries';

  @override
  String get statCities => 'Cities';

  @override
  String get statKmFlown => 'km flown';

  @override
  String get statTrips => 'Trips';

  @override
  String get goVentusPro => 'Go Ventus Pro';

  @override
  String get goVentusProSub => 'Unlimited trips, offline maps & more';

  @override
  String get menuCollaborators => 'Collaborators';

  @override
  String get menuNotifications => 'Notifications';

  @override
  String get menuSavedPlaces => 'Saved places';

  @override
  String get menuCurrencyUnits => 'Currency & units';

  @override
  String get menuSettings => 'Appearance & language';

  @override
  String get menuPrivacySecurity => 'Account & security';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get logOut => 'Log out';

  @override
  String get settingsTitle => 'Appearance & language';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get whereTo => 'Where to?';

  @override
  String get destinationSubtitle =>
      'Add one or more places — Ventus plans the route between them.';

  @override
  String get searchCityCountry => 'Search a city or country';

  @override
  String get popularRightNow => 'Popular right now';

  @override
  String get addAnotherStop => 'Add another stop';

  @override
  String get recent => 'Recent';

  @override
  String get popularDestinations => 'Popular destinations';

  @override
  String placesMatch(int count, String query) {
    return '$count places match “$query”';
  }

  @override
  String addPlace(String name) {
    return 'Add “$name”';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get searchingPlaces => 'Searching…';

  @override
  String get keepTyping => 'Type at least 3 letters to search';

  @override
  String get searchPlacesFailed => 'Couldn’t search — add it manually below.';

  @override
  String get aiTitle => 'Tell Ventus about your trip';

  @override
  String get aiSubtitle =>
      'Describe your trip in your own words — Ventus fills in the details.';

  @override
  String get aiPromptHint =>
      'A 5-day food & culture trip to Istanbul and Cappadocia for two, mid-June.';

  @override
  String get aiExamplesLabel => 'Quick start';

  @override
  String get aiExampleRomanticLabel => 'Romantic weekend';

  @override
  String get aiExampleRomanticText =>
      'A short romantic getaway for two this weekend, somewhere nearby.';

  @override
  String get aiExampleFamilyLabel => 'Family getaway';

  @override
  String get aiExampleFamilyText =>
      'A 7-day beach holiday in August with our family (2 adults, 2 kids).';

  @override
  String get aiExampleFriendsLabel => 'Trip with friends';

  @override
  String get aiExampleFriendsText =>
      'A 3-day mountain trip with 4 friends in September, hiking and nature.';

  @override
  String get aiExampleSoloLabel => 'Solo trip';

  @override
  String get aiExampleSoloText =>
      'A solo 4-day culture-and-relax trip to a quiet city in October.';

  @override
  String get aiExampleCityLabel => 'Short city break';

  @override
  String get aiExampleCityText =>
      'A short 3-day weekend city break — historic sights and local food.';

  @override
  String get aiExampleWinterLabel => 'Winter holiday';

  @override
  String get aiExampleWinterText =>
      'A 5-day winter holiday at a snowy mountain resort in January, skiing and hot chocolate.';

  @override
  String get ventusUnderstood => 'Ventus understood';

  @override
  String get whosComing => 'Who’s coming?';

  @override
  String get travelersSubtitle =>
      'This helps Ventus set the right pace and suggestions.';

  @override
  String get travelerSolo => 'Solo';

  @override
  String get travelerCouple => 'Couple';

  @override
  String get travelerFamily => 'Family';

  @override
  String get travelerFriends => 'Friends';

  @override
  String get travelersAdults => 'Adults';

  @override
  String get travelersAdultsSub => 'Age 13+';

  @override
  String get travelersChildren => 'Children';

  @override
  String get travelersChildrenSub => 'Age 0–12';

  @override
  String get inviteCompanions => 'Invite companions';

  @override
  String get inviteCompanionsSub => 'Optional · plan together';

  @override
  String get inviteAdd => 'Add';

  @override
  String get inviteAfterCreate =>
      'They\'ll be invited once you create the trip.';

  @override
  String get when => 'When?';

  @override
  String get datesSubtitle =>
      'Pick your dates, or stay flexible — you can change this later.';

  @override
  String get presetThisWeekend => 'This weekend';

  @override
  String get presetNextWeek => 'Next week';

  @override
  String get presetInAMonth => 'In a month';

  @override
  String get presetFlexible => 'I’m flexible';

  @override
  String get reviewTrip => 'Review trip';

  @override
  String get selectDates => 'Select dates';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '$count night',
    );
    return '$_temp0';
  }

  @override
  String get reviewTitle => 'Review';

  @override
  String stopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '$count stop',
    );
    return '$_temp0';
  }

  @override
  String get routeLabel => 'Route';

  @override
  String get travelersLabel => 'Travelers';

  @override
  String get datesLabel => 'Dates';

  @override
  String get editAction => 'Edit';

  @override
  String adultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adults',
      one: '$count adult',
    );
    return '$_temp0';
  }

  @override
  String childrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count children',
      one: '$count child',
    );
    return '$_temp0';
  }

  @override
  String get buildPlanWithAi => 'Build my plan with AI';

  @override
  String get createEmptyTrip => 'Build it myself';

  @override
  String get reviewFootnote =>
      'No bookings here — add tickets & documents anytime.';

  @override
  String get tripCreated => 'Trip created';

  @override
  String get tripNotFound => 'Trip not found.';

  @override
  String get tripDetailsTitle => 'Trip details';

  @override
  String get tripOverviewTab => 'Overview';

  @override
  String get moduleItinerary => 'Itinerary';

  @override
  String get moduleBudget => 'Budget';

  @override
  String get moduleDocuments => 'Documents';

  @override
  String get moduleChecklist => 'Checklist';

  @override
  String get moduleChecklistShort => 'Checklist';

  @override
  String get moduleMap => 'Map';

  @override
  String get seeOnMap => 'See on map';

  @override
  String get mapRouteTitle => 'Route';

  @override
  String get emptyMapTitle => 'Nothing to map yet';

  @override
  String get emptyMapBody =>
      'Add places to your trip and they\'ll appear here on the map.';

  @override
  String get emptyMapNoCoords =>
      'The places on this trip don\'t have locations yet. Tap below to put them on the map.';

  @override
  String get mapFilterAll => 'All';

  @override
  String get mapLocating => 'Finding places…';

  @override
  String get mapFindPlaces => 'Find places';

  @override
  String mapMissingPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places have no location',
      one: '$count place has no location',
    );
    return '$_temp0';
  }

  @override
  String mapPlacesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '$count place',
    );
    return '$_temp0';
  }

  @override
  String mapDayDistance(String km) {
    return '~$km km';
  }

  @override
  String get mapDayEmpty => 'Nothing on this day is on the map yet';

  @override
  String get mapShowInPlan => 'Show in the day plan';

  @override
  String mapLocated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places added to the map',
      one: '$count place added to the map',
    );
    return '$_temp0';
  }

  @override
  String get mapNothingLocated => 'No new places found';

  @override
  String get mapLocateFailed =>
      'Couldn\'t find the places. Check your connection.';

  @override
  String aiHubTitle(String city) {
    return 'Let Ventus plan $city';
  }

  @override
  String get aiHubBody =>
      'A day-by-day itinerary tuned to your dates, pace and the places you picked — ready in seconds.';

  @override
  String get aiHubGenerate => 'Generate my plan';

  @override
  String get aiGenerating => 'Crafting your plan…';

  @override
  String get aiPlanReady => 'Your plan is ready';

  @override
  String get aiNeedsDestination => 'Add a destination first.';

  @override
  String get aiPlanUnavailable => 'AI planning isn\'t available yet.';

  @override
  String get aiPlanNetworkError =>
      'Couldn\'t reach the planner. Check your connection and try again.';

  @override
  String get aiPlanEmpty => 'Couldn\'t build a plan. Try again in a moment.';

  @override
  String get aiPlanFailed => 'Couldn\'t generate a plan. Try again.';

  @override
  String get aiNeedDescription => 'Describe your trip first.';

  @override
  String get aiReadingTrip => 'Reading your trip…';

  @override
  String get aiParseEmpty =>
      'Couldn\'t find a place in that. Try naming a city.';

  @override
  String get aiParseFailed => 'Couldn\'t read your trip. Try again.';

  @override
  String get orStartManually => 'Or start manually';

  @override
  String get startBuildItinerary => 'Build itinerary';

  @override
  String get startBuildItinerarySub => 'Add days and activities yourself';

  @override
  String get startUploadDocs => 'Upload tickets & documents';

  @override
  String get startUploadDocsSub =>
      'Flights, hotels, passports — all in one place';

  @override
  String get startChecklist => 'Create a checklist';

  @override
  String get startChecklistSub => 'Track what to pack and prepare';

  @override
  String get deleteTripAction => 'Delete trip';

  @override
  String get deleteTripTitle => 'Delete this trip?';

  @override
  String get deleteTripBody =>
      'This removes the trip and its details. This can’t be undone.';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String get tripDeleted => 'Trip deleted';

  @override
  String get dayLabel => 'Day';

  @override
  String get emptyDayTitle => 'Nothing planned yet';

  @override
  String get emptyDayBody => 'Add your first activity for this day.';

  @override
  String get addActivity => 'Add activity';

  @override
  String get newActivity => 'New activity';

  @override
  String get editActivity => 'Edit activity';

  @override
  String get activityTitleLabel => 'Name';

  @override
  String get activityTitleHint => 'e.g. Bosphorus sunset walk';

  @override
  String get activityTitleRequired => 'Add a short title';

  @override
  String get activityPlaceLabel => 'Place';

  @override
  String get activityPlaceHint => 'e.g. Karaköy';

  @override
  String get activityTimeLabel => 'Time';

  @override
  String get activityAddTime => 'Add a time';

  @override
  String get activityMoreDetails => 'Add place or time';

  @override
  String get activityKindLabel => 'Type';

  @override
  String get activityDayLabel => 'Day';

  @override
  String get kindFlight => 'Flight';

  @override
  String get kindStay => 'Stay';

  @override
  String get kindFood => 'Food';

  @override
  String get kindSight => 'Sight';

  @override
  String get kindTransport => 'Transport';

  @override
  String get kindActivity => 'Activity';

  @override
  String get save => 'Save';

  @override
  String get selectTime => 'Select time';

  @override
  String get setTime => 'Set time';

  @override
  String get deleteActivity => 'Delete activity';

  @override
  String get deleteActivityTitle => 'Delete this activity?';

  @override
  String get aiAssistTitle => 'Some days are still open';

  @override
  String get aiAssistBody => 'Let Ventus draft them for you';

  @override
  String get planAction => 'Plan';

  @override
  String checklistProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get checklistItemHint => 'e.g. Passport valid 6+ months';

  @override
  String get renameChecklistItem => 'Rename item';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get undo => 'Undo';

  @override
  String get emptyChecklistTitle => 'Nothing to check off yet';

  @override
  String get emptyChecklistBody => 'Add what you need to pack and prepare.';

  @override
  String get checklistCatBeforeYouGo => 'Before you go';

  @override
  String get checklistCatPack => 'Pack';

  @override
  String get checklistCatOnArrival => 'On arrival';

  @override
  String get defChkVisa => 'Check / apply for visa';

  @override
  String get defChkInsurance => 'Travel insurance';

  @override
  String get defChkCheckin => 'Online check-in';

  @override
  String get defChkCash => 'Exchange currency / cash';

  @override
  String get defChkPassport => 'Passport';

  @override
  String get defChkTickets => 'Tickets (flight / train)';

  @override
  String get defChkId => 'ID card';

  @override
  String get defChkCharger => 'Charger / adapter';

  @override
  String get defChkSim => 'Local SIM / eSIM';

  @override
  String get defChkHotel => 'Hotel check-in';

  @override
  String get defChkTransport => 'Local transport';

  @override
  String get addItem => 'Add item';

  @override
  String get addToChecklist => 'Add to checklist';

  @override
  String get editChecklistItem => 'Edit item';

  @override
  String get deleteChecklistItem => 'Delete item';

  @override
  String get checklistCategoryLabel => 'Category';

  @override
  String get setReminder => 'Set a reminder';

  @override
  String dueBy(String date) {
    return 'Do by $date';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '$count file',
    );
    return '$_temp0';
  }

  @override
  String get docPhotoName => 'Photo';

  @override
  String get docFileName => 'File';

  @override
  String get docGroupTickets => 'Tickets';

  @override
  String get docGroupStays => 'Stays';

  @override
  String get docGroupIdentity => 'Identity';

  @override
  String get docGroupOther => 'Other';

  @override
  String get docGroupTripWide => 'Trip-wide';

  @override
  String get docTypeTicket => 'Ticket';

  @override
  String get docTypeStay => 'Stay';

  @override
  String get docTypeId => 'ID';

  @override
  String get docTypeOther => 'Other';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get addDocumentTitle => 'Add a document';

  @override
  String get addDocumentBody =>
      'Tickets, vouchers & IDs stay private to this trip.';

  @override
  String get sourceFiles => 'Files';

  @override
  String get sourceFilesSub => 'PDF, Pages, anything';

  @override
  String get sourceCamera => 'Camera';

  @override
  String get sourceCameraSub => 'Scan a paper ticket or ID';

  @override
  String get sourcePhotos => 'Photos';

  @override
  String get sourcePhotosSub => 'Pick from your library';

  @override
  String get saveDocumentTitle => 'Save document';

  @override
  String get documentTypeLabel => 'Type';

  @override
  String get linkToDayLabel => 'Link to day (optional)';

  @override
  String get saveToDocuments => 'Save to Documents';

  @override
  String docDayWithDate(int day, String date) {
    return 'Day $day · $date';
  }

  @override
  String docDayShort(int day) {
    return 'Day $day';
  }

  @override
  String get editDocumentTitle => 'Edit document';

  @override
  String get documentNameLabel => 'Name';

  @override
  String get documentNameHint => 'Document name';

  @override
  String get deleteDocument => 'Delete document';

  @override
  String get deleteDocumentTitle => 'Delete this document?';

  @override
  String get deleteDocumentBody =>
      'This permanently removes the file. This can’t be undone.';

  @override
  String get documentDeleted => 'Document deleted';

  @override
  String get docActionShare => 'Share';

  @override
  String get docActionSave => 'Save';

  @override
  String get docActionEdit => 'Edit';

  @override
  String get docActionDelete => 'Delete';

  @override
  String documentLinkedTo(String day) {
    return 'Linked to $day';
  }

  @override
  String get openFile => 'Open';

  @override
  String get previewUnavailable => 'Preview isn’t available here.';

  @override
  String get connectToView => 'Connect to the internet to view this file.';

  @override
  String get emptyDocumentsTitle => 'No documents yet';

  @override
  String get emptyDocumentsBody =>
      'Upload your tickets, vouchers and IDs to keep them handy.';

  @override
  String get uploadFailed => 'Couldn’t upload — try again.';

  @override
  String get budgetRemaining => 'Remaining';

  @override
  String budgetOfTotal(String total) {
    return 'of $total';
  }

  @override
  String budgetSpentUsed(String spent, int percent) {
    return '$spent spent · $percent% used';
  }

  @override
  String budgetLeftPct(int percent) {
    return '$percent% left';
  }

  @override
  String get budgetByCategory => 'By category';

  @override
  String get budgetExpenses => 'Expenses';

  @override
  String get addExpense => 'Add expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get budgetTotalLabel => 'Total trip budget';

  @override
  String get budgetAllocateByCategory => 'Allocate by category';

  @override
  String get budgetAllocated => 'Allocated';

  @override
  String get budgetSave => 'Save budget';

  @override
  String get budgetCurrency => 'Currency';

  @override
  String get expCatStay => 'Stay';

  @override
  String get expCatFood => 'Food';

  @override
  String get expCatSight => 'Sights';

  @override
  String get expCatTransport => 'Transport';

  @override
  String get expCatOther => 'Other';

  @override
  String get expenseNoteHint => 'Add a note…';

  @override
  String addAmountTo(String amount, String category) {
    return 'Add $amount to $category';
  }

  @override
  String get budgetUnassigned => 'Unassigned';

  @override
  String get deleteExpense => 'Delete expense';

  @override
  String get deleteExpenseTitle => 'Delete this expense?';

  @override
  String get expenseDeleted => 'Expense deleted';

  @override
  String get amountRequired => 'Enter an amount';

  @override
  String get emptyExpensesBody => 'No expenses logged yet.';

  @override
  String get setBudgetTitle => 'Set your trip budget';

  @override
  String get setBudgetBody =>
      'Add a total and Ventus tracks what’s left as you spend.';

  @override
  String get setBudget => 'Set a budget';

  @override
  String get privacySectionAppLock => 'App lock';

  @override
  String get privacySectionAccount => 'Account';

  @override
  String get privacySectionDanger => 'Danger zone';

  @override
  String get privacyChangePin => 'Change PIN';

  @override
  String get privacyChangePinSub => 'Quick-unlock PIN for this device';

  @override
  String get privacyChangePasswordSub => 'Update your account password';

  @override
  String get privacyDeleteAccount => 'Delete account';

  @override
  String get privacyDeleteAccountSub =>
      'Permanently remove your account and data';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account and all your trips. This can\'t be undone.';

  @override
  String get accountDeleted => 'Your account has been deleted';

  @override
  String get changePinTitle => 'Change PIN';

  @override
  String get changePinVerifyTitle => 'Enter current PIN';

  @override
  String get changePinVerifyBody =>
      'Confirm it\'s you before changing your PIN.';

  @override
  String get changePinNewTitle => 'Choose a new PIN';

  @override
  String get changePinNewBody => 'Pick a 4-digit PIN you\'ll remember.';

  @override
  String get changePinConfirmTitle => 'Re-enter new PIN';

  @override
  String get changePinConfirmBody => 'Type your new PIN again to confirm.';

  @override
  String get changePinWrong => 'Incorrect PIN. Try again.';

  @override
  String get changePinMismatch => 'PINs didn\'t match. Start again.';

  @override
  String get pinChanged => 'PIN updated';

  @override
  String get pinTooWeak =>
      'That PIN is too easy to guess. Try a different one.';

  @override
  String get pinLockedOut => 'Too many attempts. Try again in';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordAction => 'Update password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm new password';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match.';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect.';

  @override
  String get passwordChanged => 'Password updated';

  @override
  String get authWeakPassword =>
      'Password is too weak. Use at least 8 characters.';

  @override
  String get authSamePassword =>
      'New password must be different from the current one.';

  @override
  String get proTitle => 'Ventus Pro';

  @override
  String get proTagline => 'Plan without limits.';

  @override
  String get proBillingYearly => 'Yearly';

  @override
  String get proBillingMonthly => 'Monthly';

  @override
  String get proSave => 'Save 30%';

  @override
  String get proPerYear => '/yr';

  @override
  String get proPerMonth => '/mo';

  @override
  String get proYearlyEquiv => '≈ \$3.50/mo';

  @override
  String get proBilledMonthly => 'billed monthly';

  @override
  String get proColFeature => 'Feature';

  @override
  String get proColFree => 'Free';

  @override
  String get proColPro => 'Pro';

  @override
  String get proRowTrips => 'Active trips';

  @override
  String get proRowAiPlans => 'AI day plans';

  @override
  String get proRowOfflineMaps => 'Offline maps';

  @override
  String get proRowCollaborators => 'Collaborators';

  @override
  String get proRowVault => 'Document vault';

  @override
  String get proFreeAiPlansPerMonth => '5/mo';

  @override
  String get proCtaTrial => 'Start 7-day free trial';

  @override
  String get proComingSoon =>
      'We\'re still building Ventus Pro. We\'ll let you know when it\'s ready.';

  @override
  String get proThenYearly => 'Then \$41.99/yr · cancel anytime';

  @override
  String get proThenMonthly => 'Then \$4.99/mo · cancel anytime';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notifToday => 'Today';

  @override
  String get notifEarlier => 'Earlier';

  @override
  String get notifMarkRead => 'Mark all read';

  @override
  String get notifEmptyTitle => 'No notifications yet';

  @override
  String get notifEmptyBody =>
      'Trip activity and AI updates will show up here.';

  @override
  String notifNewCount(int count) {
    return '$count new';
  }

  @override
  String notifCollabInvitedTitle(String email) {
    return 'Invited $email';
  }

  @override
  String notifCollabInvitedBody(String trip) {
    return 'Trip: $trip. Invite sent.';
  }

  @override
  String get notifCollabInvitedBodyShort => 'Invite sent.';

  @override
  String get notifAiReadyTitle => 'Your AI day plan is ready';

  @override
  String notifAiReadyBody(String trip) {
    return 'Trip: $trip';
  }

  @override
  String get notifAccepted => 'Accepted';

  @override
  String get notifAcceptInvite => 'Accept';

  @override
  String get notifGenericTitle => 'Update';

  @override
  String get notifWelcomeTitle => 'Welcome to Ventus 👋';

  @override
  String get notifWelcomeBody =>
      'Your account is ready. Plan your first trip and let Ventus handle the details.';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String timeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get changeCoverPhoto => 'Change cover photo';

  @override
  String get coverUpdated => 'Cover updated';

  @override
  String get coverRemove => 'Remove cover photo';

  @override
  String get notifDeleteAll => 'Delete all';

  @override
  String get notifConfirmMarkAllReadTitle => 'Mark all as read?';

  @override
  String get notifConfirmMarkAllReadBody =>
      'All notifications will be marked as read.';

  @override
  String get notifConfirmDeleteAllTitle => 'Delete all notifications?';

  @override
  String get notifConfirmDeleteAllBody =>
      'This permanently removes all your notifications. This can’t be undone.';

  @override
  String get notifMarkReadConfirm => 'Mark read';

  @override
  String get notifDeleteAllConfirm => 'Delete all';

  @override
  String get tripStatDaysLeft => 'days to go';

  @override
  String get tripStatPlanned => 'planned';

  @override
  String greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get nextStepEyebrow => 'Next step';

  @override
  String get nextStepPlanTitle => 'Build your day-by-day plan';

  @override
  String get nextStepPlanBody =>
      'Add the first activity — the rest comes easily.';

  @override
  String get nextStepChecklistTitle => 'Start a checklist';

  @override
  String get nextStepChecklistBody =>
      'What shouldn\'t you forget before leaving?';

  @override
  String get nextStepBudgetTitle => 'Set a budget';

  @override
  String get nextStepBudgetBody => 'Track spending as it happens.';

  @override
  String get nextStepDocsTitle => 'Add your documents';

  @override
  String get nextStepDocsBody => 'Keep tickets and bookings in one place.';

  @override
  String get planCompleteTitle => 'Plan complete';

  @override
  String get planCompleteBody => 'Every day is planned. Have a great trip!';

  @override
  String get tripDeleteOwnerOnly => 'Only the owner can delete this trip.';

  @override
  String get collabTripOwner => 'Trip owner';

  @override
  String get overviewReadiness => 'Getting ready';

  @override
  String get overviewNextUp => 'Up next';

  @override
  String readinessDaysPlanned(int planned, int total) {
    return '$planned/$total days planned';
  }

  @override
  String readinessActivities(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '$count activity',
    );
    return '$_temp0';
  }

  @override
  String get readinessBudgetNotSet => 'Not set yet';

  @override
  String get readinessNoDocs => 'Nothing uploaded';

  @override
  String get readinessEmpty => 'Nothing here yet';

  @override
  String get openInMaps => 'Open in maps';

  @override
  String get taxiSection => 'Taxi';

  @override
  String datesPickStartOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '$count night',
    );
    return 'You said $_temp0 — just pick the day you leave.';
  }

  @override
  String get checklistAllDone => 'All set. Safe travels!';

  @override
  String get profileSectionSupport => 'Support';

  @override
  String get menuAbout => 'About';

  @override
  String get menuHelp => 'Help';

  @override
  String get menuContact => 'Contact us';

  @override
  String get aboutTagline => 'Plan, keep and follow your trip in one place.';

  @override
  String get aboutLegalSection => 'Legal';

  @override
  String get contactMailSubject => 'Ventus support';

  @override
  String contactMailBody(String version, String device) {
    return 'Hi, my question/problem:\n\n\n— App: $version\n— Device: $device';
  }

  @override
  String get contactMailFailed =>
      'Couldn\'t open your mail app. Write to us at support@ventus.app';

  @override
  String get helpQ1 => 'How do I create a trip?';

  @override
  String get helpA1 =>
      'Tap the + button in the middle of the home screen, then pick the place and dates. You can also choose “Plan with AI” and describe your trip in a sentence — it finds the place, dates and who\'s going.';

  @override
  String get helpQ2 => 'How does the AI plan work?';

  @override
  String get helpA2 =>
      'On your trip\'s page tap “Generate my plan” and Ventus suggests a day-by-day plan. It\'s guidance only — always double-check times, prices and bookings yourself.';

  @override
  String get helpQ3 => 'Does it work offline?';

  @override
  String get helpA3 =>
      'Your trips, day plan, checklist and budget are stored on your phone and open without internet. They sync when you\'re back online. AI, maps, weather and currency need internet.';

  @override
  String get helpQ4 => 'Where are my documents stored?';

  @override
  String get helpA4 =>
      'Your tickets and other documents are kept securely in private storage that only you can open. Nobody sees them unless you share them.';

  @override
  String get helpQ5 => 'How do I open a place on the map?';

  @override
  String get helpA5 =>
      'In the day plan tap the compass icon on the right of an activity card. The maps and taxi apps on your phone appear — pick one.';

  @override
  String get helpQ6 => 'How do I delete my account?';

  @override
  String get helpA6 =>
      'Profile → Privacy & security → Delete account. This permanently deletes your account and all your trips and can\'t be undone.';
}
