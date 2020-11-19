import 'package:feed_the_parrot/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'LoginForm.dart';
import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toLanguageTag();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get appTitle {
    return Intl.message(
      'Feed the Parrot',
      name: 'appTitle',
      desc: 'Title for the application',
      locale: localeName,
    );
  }

  String get feedFormNewTitle {
    return Intl.message(
      'New feed',
      name: 'feedFormNewTitle',
      desc: 'Title for the feed form when a new feed is being created',
      locale: localeName,
    );
  }

  String get feedFormEditTitle {
    return Intl.message(
      'Edit feed',
      name: 'feedFormEditTitle',
      desc: 'Title for the feed form when an existing feed is being edited',
      locale: localeName,
    );
  }

  String get optionsTileTitle {
    return Intl.message(
      'Options',
      name: 'optionsTileTitle',
      desc: 'Title of the options expansion tile in the feed form',
      locale: localeName,
    );
  }

  String get nameField {
    return Intl.message(
      'Name',
      name: 'nameField',
      desc: 'Name of the name field of a feed',
      locale: localeName,
    );
  }

  String get languageField {
    return Intl.message(
      'Language',
      name: 'languageField',
      desc: 'Name of the language field of a feed',
      locale: localeName,
    );
  }

  String get englishLanguage {
    return Intl.message(
      'English',
      name: 'englishLanguage',
      desc: 'Name of the english language',
      locale: localeName,
    );
  }

  String get spanishLanguage {
    return Intl.message(
      'Spanish',
      name: 'spanishLanguage',
      desc: 'Name of the spanish language',
      locale: localeName,
    );
  }

  String get itemLimitField {
    return Intl.message(
      'Item limit',
      name: 'itemLimitField',
      desc: 'Name of the item limit field of a feed',
      locale: localeName,
    );
  }

  String get itemLimitHint {
    return Intl.message(
      'Max number of items this feed should return',
      name: 'itemLimitHint',
      desc:
          'Hint (explanation) of what the item limit field of a feed represents',
      locale: localeName,
    );
  }

  String get truncateContentAtField {
    return Intl.message(
      'Truncate content at',
      name: 'truncateContentAtField',
      desc: 'Name of the "truncate content at" field of a feed',
      locale: localeName,
    );
  }

  String get truncateContentAtHint {
    return Intl.message(
      'Max number of characters the content should have',
      name: 'truncateContentAtHint',
      desc:
          'Hint (explanation) of what the "truncate content at" field of a feed represents',
      locale: localeName,
    );
  }

  String get deleteDialogConfirmationTitle {
    return Intl.message(
      'Are you sure?',
      name: 'deleteDialogConfirmationTitle',
      desc: 'Title of the confirmation dialog on feed deletion',
      locale: localeName,
    );
  }

  String get deleteDialogConfirmationContent {
    return Intl.message(
      'Are you sure you want to delete the following elements?',
      name: 'deleteDialogConfirmationContent',
      desc: 'Content of the confirmation dialog on feed deletion',
      locale: localeName,
    );
  }

  String get newButtonTooltip {
    return Intl.message(
      'New',
      name: 'newButtonTooltip',
      desc: 'Tooltip for the button to add a new feed',
      locale: localeName,
    );
  }

  String get loginButtonTooltip {
    return Intl.message(
      'Login',
      name: 'loginButtonTooltip',
      desc: 'Tooltip for the login button',
      locale: localeName,
    );
  }

  String get loginInputHint {
    return Intl.message(
      'Input the code you got from the Alexa skill',
      name: 'loginInputHint',
      desc: 'Hint for the login input',
      locale: localeName,
    );
  }

  String get loginInputLabel {
    return Intl.message(
      'Code',
      name: 'loginInputLabel',
      desc: 'Label for the login input',
      locale: localeName,
    );
  }

  String get loginInputEmptyErrorMessage {
    return Intl.message(
      'The code must not be empty',
      name: 'loginInputEmptyErrorMessage',
      desc: 'Error message for the login input when it is empty',
      locale: localeName,
    );
  }

  String get requiredValueErrorMessage {
    return Intl.message(
      'Required',
      name: 'requiredValueErrorMessage',
      desc: 'Error message when a value is required',
      locale: localeName,
    );
  }

  String get valueShouldBeANumberErrorMessage {
    return Intl.message(
      'This should be a number',
      name: 'valueShouldBeANumberErrorMessage',
      desc: 'Error message when a value is not a number (and it should be one)',
      locale: localeName,
    );
  }

  String get invalidCodeErrorMessage {
    return Intl.message(
      'The code is not valid',
      name: 'invalidCodeErrorMessage',
      desc: 'Error message when the login code is not valid',
      locale: localeName,
    );
  }

  String get expiredCodeErrorMessage {
    return Intl.message(
      'The code has expired',
      name: 'expiredCodeErrorMessage',
      desc: 'Error message when the login code has expired',
      locale: localeName,
    );
  }

  String get unknownErrorMessage {
    return Intl.message(
      'An error has occured',
      name: 'unknownErrorMessage',
      desc: 'Error message when an unknown error has occured',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('es')],
      home: currentUser == null ? LoginForm() : MyHomePage(user: currentUser),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
